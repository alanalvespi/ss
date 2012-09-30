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



raise WaError.new('E-DailyMarketUpdate:ParmError, username parameter not specified, please add username="db-username" to command ') unless ENV.has_key?('username')
raise WaError.new('E-DailyMarketUpdate:ParmError, database parameter not specified, please add database="db-name"     to command ') unless ENV.has_key?('database')
raise WaError.new('E-DailyMarketUpdate:ParmError, host     parameter not specified, please add     host="hostname"    to command ') unless ENV.has_key?('host')
raise WaError.new('E-DailyMarketUpdate:ParmError, port     parameter not specified, please add     port="port-no"     to command ') unless ENV.has_key?('port')


begin 
  DB = Wa.openDatabase()
end

@TestResults = [{'Test started at:'=>Time.now}]

#mysql_exe = "c:\\wamp\\bin\\mysql\\mysql5.5.20\\bin\\mysql.exe"
#require 'open3'
#sin, sout, serr = Open3.popen3("#{mysql_exe} --user=#{ENV['username']} -e Initial_market.sql")
#results = serr.readlines 
#results += sout.readlines
   
# SQL For Initial Market Reset...
stmts = [
  
  "update markets 
     set markets.market_in = 0, 
         markets.market_reference_price = 8654.617,
         markets.market_reference_date = '2011-12-19',
         markets.market_last_switch_price = 865.617,
         markets.market_last_switch_date = '2011-12-19',
         markets.market_current_process_date = '2011-12-31'
  where markets.market_id = 194;",
   
  "update markets 
     set markets.market_in = 0, 
         markets.market_reference_price = 343.773,
         markets.market_reference_date = '2011-12-20',
         markets.market_last_switch_price = 343.773,
         markets.market_last_switch_date = '2011-12-20',
         markets.market_current_process_date = '2011-12-31'
  where markets.market_id = 94;",
  
   
  "update markets 
     set markets.market_in = 0, 
         markets.market_reference_price = 55.579,
         markets.market_reference_date = '2011-12-19',
         markets.market_last_switch_price = 55.579,
         markets.market_last_switch_date = '2011-12-19',
         markets.market_current_process_date = '2011-12-31'
  where markets.market_id = 92;"
]





# Initialize Market records...
count = 0
stmts.each do |s| 
  DB.run(s) 
end

# Run Calculate Switches...



puts @TestResults
