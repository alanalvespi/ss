require "rubygems"
require "sequel"

class WaError < StandardError
  attr_reader :severity, :routine, :errcode, :reason, :msg, :prev
  def initialize(msg,prev = nil)
    @msg      =  "\n" + msg
    @prev     = prev
    if (msg =~ /(E|W|I|D)-(\w*):(\w*),(.*)/) then
      @severity = $1
      @routine  = $2
      @errcode  = $3
      @reason   = $4
    end
  end
      
  def to_s
    t = msg
    t = t + @prev.to_s if (@prev)
    return t
  end    
end
  

module Wa
  def Wa.loadArguments(argdef)
    valuta = nil
    ARGV.each do |pair|
      name, value = pair.split(/=/)
      if (argdef.has_key?(name)) then
        ENV[name] = value
        puts "#{name}=#{value}"
      end      
    end
    
    # fill default values
    argdef.each do |name,value|
      ENV[name] = value unless ENV.has_key?(name)
    end
    
    # Process Global parameters
    
  end
  
  
  def Wa.openDatabase()
    #envcfg = readme = YAML::load( File.open( "../../config/database.yml" ) )
    #env    = envcfg[envname]
    puts "Using database database: #{ENV['database']}, :user => #{ENV['username']}, :password => #{ENV['password']}, :host => #{ENV['host']}, :port => #{ENV['port']}"
    begin 
      return Sequel.mysql2(ENV['database'], :user => ENV['username'], :password => ENV['password'], :host => ENV['host'], :port => ENV['port'].to_i)
    rescue Exception => e
      raise WaError.new("E-openDatabase:ConnectionFailed, Connection to database:#{ENV['database']}, :user => #{ENV['username']}, :password => #{ENV['password']}, :host => #{ENV['host']}, :port => #{ENV['port']} failed",e)
    end
  end
  
end