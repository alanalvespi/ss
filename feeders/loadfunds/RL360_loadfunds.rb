require 'rubygems'
require 'sequel'
require 'roo'
require 'yaml'
require '../util/wa'

# Todays Date
as_of  = Date.today
day   = "%02d" % as_of.day
month = "%02d" % as_of.month
year  = "%4d" % as_of.year


dirname = ''
['../../public/data/feeders/loadfunds',year,month,day].each do |part| 
 dirname = dirname + part + '/'
 Dir::mkdir(dirname) unless FileTest::directory?(dirname) 
end

log_fn = "#{dirname}loadfunds.log"
puts "redirecting output to #{log_fn}"

$stdout.reopen(log_fn,"w")
$stderr = $stdout
puts "output redirected to #{log_fn}"

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



#
# Load Funds for company RL360 from XLS
#



# build regex for FInding currency
Currencies = ['EUR','USD', 'AUD', 'GBP', 'CHF', 'JPY', 'RUS', 'Sfr', 'US\$', 'Euro' ]
Cur_trans  = {'EUR'=>'EUR' ,'USD'=>'USD' , 'AUD'=>'AUD' , 'GBP'=>'GBP' , 'CHF'=>'CHF' , 'JPY'=>'JPY' , 'RUS'=>'RUS' , 'Sfr'=>'CHF' , 'US$'=>'USD' , 'Euro'=>'EUR'}
Cur_reg =  "(#{Currencies.join('|')})"



# Function to return currency from name
def getCurrency(line) 
  reg = Regexp.new(Cur_reg)
  if (cur = reg.match(line)) then
    cur = Cur_trans[cur.to_s]
  end
  raise WaError.new("E-getCurrency:ParseFailed, could not parse currency in <#{line}>") unless cur
  return cur
end


# Get Database Info
DB = Wa.openDatabase()

company_id       = DB[:companies].filter(:company_name => 'RL360').select(:company_id).single_value
db_Funds         = DB[:plantypefunds].filter(:company_id => company_id).map {|r| "#{r[:plantype_id]}:#{r[:fund_identifier]}"}
plantype_list    = DB[:plantypes].map {|r| r[:plantype_id]}
db_PlantypeFunds = DB[:plantypefunds]


xls_fname = 'data/RL360/RL360_Funds.xls'

book = Excel.new(xls_fname)
book.default_sheet = book.sheets.first
last_row  = book.last_row

# Loop over all Rows...
$rowno = 3
$rowsinserted = 0
$rowsupdated  = 0
$rowsignored  = 0
$errors       = 0
$now          = Time.now
4.upto(last_row) do |row|
  begin  
    $rowno = $rowno + 1
    identifier = book.cell(row,'A').to_i
    flds ={:created_at=>$now,:updated_at=>$now,:state=>0,:reason=>nil}
    if (identifier == 0) then
      flds[:state]=1
      flds[:reason]='has no internal id'  
      $errors = $errors + 1 
      puts WaError.new("E-RL360_loadfunds:NoIntId, No Internal Id, Could not process row #{$rowno}") 
    end

    pppcode    = book.cell(row,'B').to_i
    name       = book.cell(row,'C')
    isin       = book.cell(row,'D')
    notes      = book.cell(row,'E')
    begin
      currency   = getCurrency(name)
    rescue WaError => e
      puts WaError.new("E-RL360_loadfunds:InvalidRow, Could not process row #{$rowno} ",e)
      flds[:state]=1
      flds[:reason]=e.reason
      $errors = $errors + 1  
    end
    
    plantype_list.each() do |pid|
      db_Fund = DB[:plantypefunds].filter(:company_id=>company_id, :plantype_id=>pid, :fund_identifier=>identifier ).first
      if (db_Fund) then
        fund_id =db_Fund[:fund_id]
        # Okay we got Record...  Update fields....
        flds[:fund_isin]     = isin     if (isin     != db_Fund[:fund_isin])
        flds[:fund_currency] = currency if (currency != db_Fund[:fund_currency])
        flds[:updated_at]    = $now
        x = DB[:plantypefunds].filter(:fund_id=>fund_id).update(flds)
        $rowsupdated = $rowsupdated + 1  
              
      else
        # No record Found... Insert it into the DB
        DB[:plantypefunds].insert(
                :fund_name        => name,
                :fund_identifier  => identifier,
                :fund_currency    => currency,
                :company_id       => company_id,
                :plantype_id      => pid,
                :fund_isin        => isin,
                :created_at       =>$now,
                :updated_at       => $now,
                :state            =>0, 
                :reason           =>nil)
        $rowsinserted = $rowsinserted + 1      
      end
    end
  rescue WaError => e
    puts WaError.new("W-RL360_loadfunds:IgnoringRow, Ignoring Row #{$rowno}",e)
    $rowsignored = $rowsignored + 1      

  end
        
end    
puts "No of Rows Inserted : #{$rowsinserted}"
puts "No of Rows Updated  : #{$rowsupdated}"
puts "No of Rows Ignored  : #{$rowsignored}"
puts "No of Errors        : #{$errors}"
