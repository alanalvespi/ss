require 'rubygems'
require 'csv'
require "net/http"
require "uri"
require 'json'
require 'yaml'
require 'sequel'
require 'fundprice'
require 'exchangerate'
require 'rl360_isin'
require 'rl360_classes'
require '../util/wa'



#
# Load Job Parameters
#
valuta = nil
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

raise WaError.new('E-DailyMarketUpdate:ParmError, username parameter not specified, please add username="db-username" to command ') unless ENV.has_key?('username')
raise WaError.new('E-DailyMarketUpdate:ParmError, password parameter not specified, please add password="db-password" to command ') unless ENV.has_key?('password')
raise WaError.new('E-DailyMarketUpdate:ParmError, database parameter not specified, please add database="db-name"     to command ') unless ENV.has_key?('database')
raise WaError.new('E-DailyMarketUpdate:ParmError, host     parameter not specified, please add     host="hostname"    to command ') unless ENV.has_key?('host')


$now = Time.now
RL360_ISIN::Load()              # load Isins

$db = Wa.openDatabase()   # connect to database



begin
  Company.load($db)
  Plantype.load($db)
  Plantypefund.load($db) 
  Client.load($db)
  Policy.load($db) 
  Policyfund.load($db) 
rescue Exception => e
  raise WaError.new("E-RL360ClientUpdate:DbLoadFailure, Failed to load data from database",e)
end

company_name = 'RL360'
unless (company = Company.find(:company_name=>company_name)) then
  raise WaError.new("E-RL360ClientUpdate:InvData, Did not find the company definition for #{company_name}")
end

# Data Conversion Helpers
plantypes     = {'CL'=>'Oracle','QN'=>'Quantum','PM'=>'Portafolio Management Service'}
premiumtypes  = {'CL'=>true,'QN'=>false,'PM'=>true}


#
# Begin Loop over XLS
csv_file = 'data/RL360 Daily.CSV'
rowno = 0

$clientsinserted      = 0
$plantypesinserted    = 0
$policiesinserted     = 0
$plantypesinserted    = 0
$policyfundsinserted  = 0
$errors               = 0

last_policy   = nil
last_plantype = nil

CSV.open(csv_file, 'r',  ',') do |row|
  rowno = rowno + 1
  next unless (row[0])  # Skip empty Rows

  # Gather fields to be used... 
  policy_number            = row[0].to_s    # Force string
  client_name              = row[1].to_s
  policy_start             = row[2]
  #                        = row[3]
  policy_currency          = row[4].to_s
  policy_total_invested    = row[5]
  policy_additional        = row[6]
  #                        = row[7]
  fund_identifier          = row[8].to_s
  policy_amount_on_deposit = row[8]
  fund_name                = row[9].to_s
  units_1                  = row[10]
  units_2                  = row[11]
  fund_currency            = row[12]
  
  # Calculated fields
  pt = policy_number[0..1]
  plantype_name         = plantypes[pt]
  policy_single_premium = premiumtypes[pt]
  units_1 = 0 unless (units_1)
  units_2 = 0 unless (units_2)
  policyfund_units      = Float(units_1) + Float(units_2)
  if (policy_currency == fund_currency) then
    exchange_rate = 1.0
  else
    exchange_rate = ExchangeRate::Get(fund_currency,policy_currency)
  end       
  isin = RL360_ISIN::ISINS[fund_identifier]
  unless (isin) then
    puts WaError.new("E-RL360UpdateClient:NoIsin, Unknown Isin for #{fund_identifier} in Policy #{policy_number}, on row #{rowno}") 
    $errors = $errors + 1
    next
  end
  begin
    fund_bid_price = FundPrice::Get(isin)
    policyfund_value = policyfund_units * fund_bid_price * exchange_rate
  rescue Exception => e
    puts WaError.new("E-RL360UpdateClient:FundFail, Could not update fund #{fund_identifier} for policy #{policy_number}, on row #{rowno}, reason: #{e.message}")
  end
  
  #
  # Now For the Update Logic...
  #
  begin    
    #
    # IF Client does not exist, add it to database... 
    #
    unless (client = Client.find(:client_name => client_name)) then
      $db[:clients].insert(:client_name=>client_name, :created_at=>$now, :updated_at=>$now, :state=>1, :reason=>"New") # Create new Client!!!
      db_client = $db[:clients].filter(:client_name => client_name).first                         # Get newly added row
      client = Client.new(db_client)
      $clientsinserted = $clientsinserted + 1      
    end
    #
    # If Plantype does not exist, add it to database
    #
    unless (plantype = Plantype.find(:plantype_name => plantype_name,:company_id=>company.company_id)) then
      $db[:plantypes].insert(
        :plantype_name=>plantype,
        :company_id=>company.company_id,
        :created_at=>$now, :updated_at=>$now, :state=>1, :reason=>"New")
      db_obj = $db[:plantypes].filter(:plantype_name => plantype_name,:company_id=>company.company_id).first # Get newly added row
      plantype = Plantype.new(db_obj)
      $plantypesinserted = $plantypesinserted + 1      
    end
    #
    # If PlantypeFunds exists, check if currency has changed, 
    # If PlantypeFunds does not exists, insert it into database
    #
    if (plantypefund = Plantypefund.find(:fund_identifier=>fund_identifier,:company_id=>company.company_id)) then
      fld = {:updated_at=> $now}
      fld[:fund_currency] = fund_currency if (plantypefund.fund_currency != fund_currency) 
      $db[:plantypefunds].filter(:fund_id=>plantypefund.fund_id).update( fld)
      plantypefund.upd(fld)  # Update local copy...
    else
      $db[:plantypefunds].insert(
        :fund_id          => nil,                 # int AUTO_INCREMENT NOT NULL,
        :fund_name        => fund_name,           # varchar(100),
        :fund_identifier  => fund_identifier,     # varchar(20),
        :market_id        => nil,                 # int,
        :fund_currency    => fund_currency,       # varchar(3),
        :fund_fkey        => nil,                 # varchar(20),
        :fund_type        => nil,                 # varchar(20),
        :company_id       => company.company_id,  # int,
        :plantype_id      => plantype.plantype_id,# int NOT NULL,
        :fund_isin        => nil,                 # varchar(45),
        :created_at       => $now,                # timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        :updated_at       => $now,
        :state            => 1,                   # smallint NOT NULL DEFAULT '0' COMMENT '0-Okay, 1-Error',
        :reason           => "New"                # varchar(255),)
        )
      o = $db[:plantypefunds].filter(:fund_identifier=>fund_identifier,:company_id=>company.company_id).first
      plantypefund = Plantypefund.new(o)
      $plantypesinserted = $plantypesinserted + 1
    end
    #
    # Update Policy
    # Fisrt time with this policy, update all static fields 
    
    if (policy = Policy.find(:policy_number=>policy_number)) then
      fld = {:updated_at=> $now}
      fld[:policy_start]    = policy_start    if (policy.policy_start    != policy_start) 
      fld[:policy_currency] = policy_currency if (policy.policy_currency != policy_currency)
      if (policy_single_premium) then
        fld[:policy_total_invested] = policy_total_invested if (policy.policy_total_invested != policy_total_invested )
      end
      $db[:policies].filter(:policy_id=>policy.policy_id).update( fld)
      policy.upd(fld)  # Update local copy...
    else  # insert into database
      $db[:policies].insert(
        :client_id                => client.client_id,
        :plantype_id              => plantype.plantype_id,
        :policy_number            => policy_number,
        :policy_start             => policy_start,
        :policy_currency          => policy_currency,
        :policy_single_premium    => policy_single_premium,
        :policy_total_invested    => policy_total_invested,
        :policy_amount_on_deposit => policy_amount_on_deposit,
        :created_at=>$now, :updated_at=>$now, :state=>1, :reason=>"New")
      db_policy = $db[:policies].filter(:policy_number => policy_number).first # Get newly added row
      policy = Policy.new(db_policy)
      $policiesinserted = $policiesinserted + 1      
    end
    
    
    #
    # if PolicyFund exists, update policyfund_value
    # if Policyfund does not exist, insert it.
    #
    if (policyfund = Policyfund.find(:policy_id=>policy.policy_id, :fund_id => plantypefund.fund_id)) then
      fld = {:updated_at=> $now}
      fld[:policyfund_value] = policyfund_value if (policyfund.policyfund_value != policyfund_value) 
      $db[:policyfunds].filter(:fund_id=>policyfund.fund_id).update( fld)
      policyfund.upd(fld)  # Update local copy...
    else
      $db[:policyfunds].insert(
          :policyfund_id    => nil,                   # int AUTO_INCREMENT NOT NULL,
          :policy_id        => policy.policy_id,      # int,
          :fund_id          => plantypefund.fund_id,  # int,
          :policyfund_value => policyfund_value,      # double COMMENT 'Value of funds held for this policy',
          :created_at => $now, :updated_at=>$now, :state => 1, :reason => "New"
          )
      o = $db[:policyfunds].filter(:policy_id=>policy.policy_id, :fund_id => plantypefund.fund_id).first # Get newly added row
      policyfund = Policyfund.new(o)
      $policyfundsinserted = $policyfundsinserted + 1      
    end
    
    #
    # We need to Update Policy in 2 pieces, 
    # 1- first time we see a policy, 
    # 2- when we see the next Policy, we need to update last_policy.policy_value
    #
    update_last_policy = false                            # Default, Do not update last policy
    if (last_policy) then                                 # if not first policy
      if (last_policy.policy_id != policy.policy_id) then  # and not same as last
        update_last_policy = true                         # then we need to update last_policy
      end
    end
     
    if(update_last_policy) then
      fld = {:updated_at=> $now}
      begin
          fld[:policy_value] = Policyfund.get_policy_value(last_policy.policy_id) 
      rescue WaError => e
        puts WaError.new("E-RL360ClientUpdate:BadPolicyValue, Could not get_policy for #{last_policy}",e)
        fld[:policy_value] = nil
        fld[:state] = 1
        fld[:reason] = "No Policy Value"
      end
      if (last_plantype.deposit_fund_id) then
        deposit_fund      = Policyfund.find(:policy_id=>last_policy.policy_id,:fund_id => last_plantype.deposit_id)
        fld[:amount_on_deposit] = deposit_fund.policyfund_value
      end
      $db[:policies].filter(:policy_id=>policy.policy_id).update(fld)
      last_policy.upd(fld)  # Update local copy...
    end
    
    # save these for next round
    last_policy   = policy 
    last_plantype = plantype
    
  rescue WaError => e
    puts WaError.new("E-RL360ClientUpdate:InvData, Invalid Data on Row #{rowno}",e)
    $errors = $errors + 1
  end
end
puts "Number of rows read            : #{rowno}"
puts "Number of rows with errors     : #{$errors}"
puts "Number of clients inserted     : #{$clientsinserted}"
puts "Number of plantypes inserted   : #{$plantypesinserted}"
puts "Number of $policies inserted   : #{$policiesinserted}"
puts "Number of $plantypes inserted  : #{$plantypesinserted}"
puts "Number of $policyfunds inserted: #{$policyfundsinserted}"
