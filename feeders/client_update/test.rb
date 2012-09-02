#
# test run program from ruby
#
puts "about to execute..."
env      = 'development'
execdir  = '.'
pgm      = 'rl360ClientUpdate.rb'
logfile  = 'test.log'
database = 'sentrysystem'
user     = 'root'
password = ''
host     = 'localhost'
port     = '3306'
#  logfile=#{logfile} 

result = system("bundle exec ruby -C#{execdir} #{pgm} database=#{database} username=#{user} password=#{password} host=#{host} port=#{port}")

#if result then
#  puts "successfully executed #{pgm}"
#else
#  puts "execution of #{pgm} returned error"
#end

