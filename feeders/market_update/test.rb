




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

#result = system("bundle exec ruby -C#{execdir} #{pgm} valuta=#{valuta} database=#{database} username=#{user} password=#{password} host=#{host} port=#{port}")

#if result then
#  puts "successfully executed #{pgm}"
#else
#  puts "execution of #{pgm} returned error"
#end


require 'find'
dir = 'data'
data = {}
Find.find(dir) do |path|
  #p "\n>>#{path}::"
  parts = path.split('/')
  t = data
  # travel/make directory structures 
  parts[0..-2].each { |p|
    next unless p
    #p "[#{p}]" 
    t[p] = {} unless t.has_key?(p) 
    t = t[p]
  }

  t[parts[-1]] = path unless FileTest.directory?(path)
end


p data