#!/usr/local/bin/ruby -w

require 'rubygems'
require 'roo'
require 'json'
require 'sequel'
require 'yaml'
require '../util/wa'

#
# Load Job Parameters
#

valuta = nil

Wa.loadArguments(
  {'valuta'=>nil,
  'username'=>nil,
  'password'=>nil,
  'database'=>nil,
  'host'=>'localhost',
  'port'=>'3306',
  'logfile'=>nil
  })

valuta = ENV['valuta'] 



raise WaError.new('E-DailyMarketUpdate:ParmError, Valuta date parameter not specified, please add valuta="YYYY-MM-DD" to command ') unless valuta
raise WaError.new('E-DailyMarketUpdate:ParmError, username parameter not specified, please add username="db-username" to command ') unless ENV.has_key?('username')
#raise WaError.new('E-DailyMarketUpdate:ParmError, password parameter not specified, please add password="db-password" to command ') unless ENV.has_key?('password')
raise WaError.new('E-DailyMarketUpdate:ParmError, database parameter not specified, please add database="db-name"     to command ') unless ENV.has_key?('database')
raise WaError.new('E-DailyMarketUpdate:ParmError, host     parameter not specified, please add     host="hostname"    to command ') unless ENV.has_key?('host')
raise WaError.new('E-DailyMarketUpdate:ParmError, port     parameter not specified, please add     port="port-no"     to command ') unless ENV.has_key?('port')

xls_list =
{ 'SC'=>{:filename=>'SC.xls',
         :market_name=>'Small Capital (SC)',
         :format=>'msibarra',
         :url=>'http://www.mscibarra.com/webapp/indexperf/excel?scope=R&priceLevel=Price&market=Developed+Markets+%28DM%29&style=C&asOf=Month+Day%2C+Year&currency=USD&size=Small+Cap&export=Excel_IEIPerfRegionalCountry'
         },
  'EM'=>{:filename=>'EM.xls',
         :market_name=>'Emerging Markets (EM)',
         :format=>'msibarra',
         :url=>'http://www.mscibarra.com/webapp/indexperf/excel?scope=R&priceLevel=Price&market=Emerging+Markets+%28EM%29&style=C&asOf=Month+Day%2C+Year&currency=USD&size=Standard+%28Large%2BMid+Cap%29&export=Excel_IEIPerfRegionalCountry'
         },
  'DM'=>{:filename=>'DM.xls',
         :market_name=>'Developed Markets (DM)',
         :format=>'msibarra',
         :url=>'http://www.mscibarra.com/webapp/indexperf/excel?scope=R&priceLevel=Price&market=Developed+Markets+%28DM%29&style=C&asOf=Month+Day%2C+Year&currency=USD&size=Standard+%28Large%2BMid+Cap%29&export=Excel_IEIPerfRegionalCountry'
         },
  'AC'=>{:filename=>'AC.xls',
         :market_name=>'All Country (AC)',
         :format=>'msibarra',
         :url=>'http://www.mscibarra.com/webapp/indexperf/excel?scope=0&priceLevel=0&market=1896&style=C&asOf=Month+Day%2C+Year&currency=15&size=77&export=Excel_IEIPerfRegional'
         }
}

def getXLS(url,filename)
  File.open(filename,'wb'){ |f|
    f << Net::HTTP.get(URI.parse(url))
  }
end

def putJson(filename,ahash)
  File.open(filename,'w'){ |f|
    f << ahash.to_json
  }
end

def putYaml(filename,ahash)
  File.open(filename,'w'){ |f|
    f << YAML.dump(ahash)
  }
end

as_of = nil

# Todays Date
as_of  = Date.parse(valuta)
day   = "%02d" % as_of.day
month = "%02d" % as_of.month
year  = "%4d" % as_of.year

dirname = ''
['../../public/data/feeders/market_update',year,month,day].each do |part| 
 dirname = dirname + part + '/'
 Dir::mkdir(dirname) unless FileTest::directory?(dirname) 
end

#logdirname = ''
#['../../public/logs/feeders/market_update',year,month,day].each do |part| 
# logdirname = logdirname + part + '/'
# Dir::mkdir(logdirname) unless FileTest::directory?(logdirname) 
#end



log_fn = "#{dirname}market_update_log.txt"
puts "redirecting output to #{log_fn}"

$stdout.reopen(log_fn,"w")
#$stderr = $stdout
puts "output redirected to #{log_fn}"


marker_fn = "#{dirname}Started_#{valuta}.mark"
marker_file = File.new(marker_fn, "w")
marker_file.close()





begin 
  DB = Wa.openDatabase()
end

$rowsupdated = 0
$rowsinserted = 0
$rowserrors = 0
Now = Time.now

def update_db(query_name, section, msci_name, msci_index_code, valuta, last,day, market) 
  begin
    flds = {:created_at=>Now,:updated_at=>Now,:state=>0,:reason=>nil}
    db_market = DB[:markets].filter(:query_name => query_name, :query_section => section, :msci_index_code => msci_index_code).first
    unless db_market then
      db_Insert = DB[:markets]
      db_Insert.insert(
        :market_classification        => market['Market'],
        :query_name                   => query_name,
        :query_section                => section,
        :market_currency              => market['Currency'],
        :market_msci_name             => msci_name,
        :market_friendly_name         => msci_name,
        :msci_index_code              => msci_index_code,
        :market_in                    => nil,
        :market_current_date          => valuta,
        :market_current_price         => last,
        :market_dailychange           => day,
        :market_reference_date        => nil,
        :market_reference_price       => nil,
        :market_change_from_ref       => nil,
        :market_change_from_switch    => nil,
        :market_override              => nil,
        :market_switch                => nil,
        :market_last_switch_date      => nil,
        :market_last_switch_price     => nil,
        :market_current_process_date  => valuta,
        :updated_at                   => Now,
        :created_at                   => Now,
        :state                        => 0,
        :reason                       => nil)
        $rowsinserted = $rowsinserted + 1      
    else
      # @note Indexes are not unique so some are already updated....
      #if (db_market[:market_current_date]) then 
      #  if (db_market[:market_current_date] >= Date.parse(valuta)) then
      #    raise WaError.new("E-DailyMarketUpdate:BadValuta, Row in Markets table has market_current_date #{db_market[:market_current_date]} newer or same as valuta #{valuta}")
      #  end
      #end 
      flds[:market_classification]= market['Market']
      flds[:market_currency]      = market['Currency']
      flds[:market_msci_name]     = msci_name 
      flds[:market_current_date]  = valuta
      flds[:market_current_price] = last
      flds[:market_dailychange]   = day
      flds[:updated_at]           = Now
      flds[:state]                = 0
      flds[:reason]               = nil
      DB[:markets].filter(:query_name => query_name, :query_section => section, :msci_index_code => msci_index_code).update(flds)
      $rowsupdated = $rowsupdated + 1
    end
  end
end

markets = {}

xls_list.keys().each do |xls_name|
  query = xls_name
  xls = xls_list[xls_name]
  xls_url = xls[:url]
  xls_url = xls_url.sub('Year',  year)
  xls_url = xls_url.sub('Month', as_of.strftime("%b"))
  xls_url = xls_url.sub('Day',   day)
  filename = dirname + xls[:filename]
  getXLS(xls_url,filename) unless File.exist?(filename)
  book = Excel.new(filename)
  book.default_sheet = book.sheets.first
  parse_index_values = false
  indexes = {}
  first_row = book.first_row
  last_row  = book.last_row
  first_cell = nil
  market = {}
  market['Market'] = xls[:market_name]
  colheads = {}
  idx = {}
  query_section = ''
  
  
  
  
  # Loop over all Rows...
  first_row.upto(last_row) do |row|
    first_cell = book.cell(row,'A')
    #puts first_cell if first_cell
    #puts first_cell[0,8] if first_cell  
    
    if (first_cell) then # if first cell not empty
      # Check what first row is....
      if (first_cell[-2,2] == ' :') then # is it a keyword?
        keyword = first_cell[0..-3]      # yes, store keyword
        market[keyword] = book.cell(row,'B')  unless keyword == 'Market'
        
      elsif ((first_cell == 'Regional Performance') or (first_cell == 'Country Performance')) then     # is it a section header
        query_section = first_cell
        market['section'] = query_section
                    
      elsif (first_cell == 'MSCI Index') then # Is it column headers?
        parse_index_values = true # we are parsing rows...
        'A'.upto('J') do |col|
          colheads[col] = book.cell(row,col)
        end          
        
      elsif (first_cell[0,8] == 'AC = All') then # is it end of Index Rows?
        parse_index_values = false # we are finished parsing rows...
        query_index = ''           # end of section...
        
      else
        if (parse_index_values) then  # Are we parsing rows?
          msci_index_code = nil
          last            = nil
          day_change      = nil
          idx = {}
          'A'.upto('J') do |col|
            head = colheads[col]
            value = book.cell(row,col)
            idx[head] = value
          end
          
          begin
            update_db(query, query_section,idx['MSCI Index'], idx['MSCI Index Code'], valuta, idx['Last'], idx['Day'], market)
          rescue WaError => e
            raise WaError.new("E-DailyMarketUpdate:Xls_ParseError, Xls:#{filename} Row:#{row}...",e) if e.severity == 'E'
            puts e
            $rowserrors = $rowerrors + 1
          end
          
          indexes[idx['MSCI Index']] = idx
        else  # we are not parsing rows... ignore
        end
      end        
    end
  end
  market['Indexes']= indexes
  market_name = market['Market']
  market_name = market_name + '_2' if (markets.has_key?(market_name))
  markets[market_name] = market
end

puts '========================================================================='
puts "Number of Rows Insterted: #{$rowsinserted}"
puts "Number of Rows Updated:   #{$rowsupdated}"
puts "Number of Rows Insterted: #{$rowserrors}"
puts "Market Update As Of: #{valuta} Complete"
#putJson( dirname + 'MakertUpdate.json',markets)
#putYaml( dirname + 'MakertUpdate.yml',markets)

File.delete(marker_fn)


 
