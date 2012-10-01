require 'rubygems'
require 'csv'
require "net/http"
require "uri"
require 'json'
require 'yaml'
require 'sequel'
require './fundprice'
require './exchangerate'
require './rl360_isin'
require './rl360_classes'
require '../util/wa'


# Todays Date
as_of  = Date.today
day   = "%02d" % as_of.day
month = "%02d" % as_of.month
year  = "%4d" % as_of.year


#dirname = ''
#['../../public/data/feeders/client_update',year,month,day].each do |part| 
# dirname = dirname + part + '/'
# Dir::mkdir(dirname) unless FileTest::directory?(dirname) 
#end

feedername = 'switch_instruction_generator'

dirname = ''
['../../public/data/feeders',feedername,year,month,day].each do |part| 
 dirname = dirname + part + '/'
 Dir::mkdir(dirname) unless FileTest::directory?(dirname) 
end



log_fn = "#{dirname}#{feedername}_log.txt"
puts "redirecting output to #{log_fn}"

$stdout.reopen(log_fn,"w")
$stderr = $stdout
puts "output redirected to #{log_fn}"


marker_fn = "#{dirname}Started_#{year}#{month}#{day}.mark"
marker_file = File.new(marker_fn, "w")
marker_file.close()


#
# Load Job Parameters
#
ARGV.each do |pair|
  name, value = pair.split(/=/)
  case name

  when 'username'
    ENV['username'] = value

  when 'password'
    value = '' unless value
    ENV['password'] = value

  when 'database'
    ENV['database'] = value

  when 'host'
    ENV['host'] = value
  end
end


ENV['host'] = 'localhost' unless ENV.has_key?('host')

raise WaError.new('E-#{feedername}:ParmError, username parameter not specified, please add username="db-username" to command ') unless ENV.has_key?('username')
raise WaError.new('E-#{feedername}:ParmError, password parameter not specified, please add password="db-password" to command ') unless ENV.has_key?('password')
raise WaError.new('E-#{feedername}:ParmError, database parameter not specified, please add database="db-name"     to command ') unless ENV.has_key?('database')
raise WaError.new('E-#{feedername}:ParmError, host     parameter not specified, please add     host="hostname"    to command ') unless ENV.has_key?('host')


$now = Time.now
RL360_ISIN::Load()              # load ISINs

$db = Wa.openDatabase()   # connect to database

# Load relevant database parts 
company_id       = DB[:companies].filter(:company_name => 'RL360').select(:company_id).single_value
markets          = DB[:markets].map {|m| m[:market_id]}
plantypes        = DB[:plantypes].filter(:company_id => company_id).map {|r| r[:plantype_id]}
policies         = DB[:policies].filter(:plantype_id => plantypes.keys)

# build hash of all funds for each plantype
plantypefunds = {}
DB[:plantypefunds].filter(:company_id => company_id) do |row|
  plantype_id = row[:plantype_id]
  fund_id     = row[:fund_id]
  market_id   = row[:market_id]
  plantypefunds[plantype_id] = [] unless plantypefunds.has_key?(plantype_id) 

  # add in/out of market
  row['market_in'] = markets[market_id]['market_in']

  # add to list of funds in plantype
  plantypefunds[plantype_id].push row 
  
end

# Now loop over all policyfunds
now          = Time.now
state = 0
reason= "" 
last_policy_id = -1
fund_count = 0
DB[:policyfunds].filter(:policy_id => policies.key).order(:policy_id,:fund_id) do |row|
  
  policy_id   = row[:policy_id]
  plantype_id = row[:plantype_id]
  fund_id     = row[:fund_id]
  
  
  if (last_policy_id != policy_id) then
    # Update Policy if it failed
    DB[:policyfunds].where(:policyfund_id => last_policyfund_id).update(:state => state, :reason => reason, :updated_at => now)
    
    # Reset counters
    state = 0
    last_policy_id = policy_id
    reason = ""
    fund_count = 0
    ptfunds = plantypefunds[plantype_id]
  end
  
  last_policyfund_id = row[:policyfund_id] 
  policy      = policies[policy_id]
  plantype    = plantypes[plantype_id]

  # check policyfunds against plantypefunds
  ptfund    = ptfunds[fund_count]  
  ptfund_id = ptfund['fund_id'] 
  
  if (fund_id < ptfund_id) then
    state = 1 
    reason += "Policy has fund #{fund_id} which is not in policyfunds "
    next # policyfund
  elsif (fund_id == ptfund_id) then
    if (row['policyfund_value'] != 0 && ptfund['market_in'] == 0) then
      state = 1 
      reason += "Policy has value in funds #{ptfund['fund_id']}:#{ptfund['fund_name']} but is out Market "
      fund_count += 1 # next plantypefund
      next            # next policyfund
    end 
    
    if (row['policyfund_value'] == 0 && ptfund['market_in'] == 1) then
      state = 1 
      reason += "Policy has no value in funds #{ptfund['fund_id']}:#{ptfund['fund_name']} but is in Market "
      fund_count += 1 # next plantypefund
      next            # next policyfund
    end 
    
    # check that policy has correct %value in fund
    # cannot be done...  as the markets have changed, 
    # and therefore the percentages will not match...
    
      fund_count += 1 # next plantypefund
      next            # next policyfund    
  else
    while (fund_id > ptfund['fund_id']) do
      state = 1 
      reason += "Policy does not have any funds #{ptfund['fund_id']}:#{ptfund['fund_name']} "
      fund_count += 1               # Next plantypefund
      ptfund = ptfunds[fund_count]
      ptfund_id = ptfund['fund_id'] 
    end
    next
  end  
  
  # We should never get here?
end

# 
# We have now checked that all policyfunds are in accordance to plantypefunds and market_in values
#


