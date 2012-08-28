#
# test run program from ruby
#
puts "about to execute..."
env      = 'production'
execdir  = 'market_update'
pgm      = 'DailyMarketUpdate.rb'
logfile  = 'test.log'
valuta   = '2012-08-28'
database = 'ss'
user     = 'deploy'
password = 'LeIhJhLFdD'
host     = 'ec2-23-23-212-26.compute-1.amazonaws.com'
port     = '3306'
#  logfile=#{logfile} 

result = system("bundle exec ruby -C#{execdir} #{pgm} valuta=#{valuta} database=#{database} username=#{user} password=#{password} host=#{host} port=#{port}")

if result then
  puts "successfully executed #{pgm}"
else
  puts "execution of #{pgm} returned error"
end
