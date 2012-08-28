

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
  
  def Wa.openDatabase(envname)
    envcfg = readme = YAML::load( File.open( "../../config/database.yml" ) )
    env    = envcfg[envname]
    puts "Using database connection: #{env['database']}, :user => #{env['username']}, :password => #{env['password']}, :host => 'localhost'"
    begin 
      return Sequel.mysql2(env['database'], :user => env['username'], :password => env['password'], :host => 'localhost')
    rescue Exception => e
      raise WaError.new("E-openDatabase:ConnectionFailed, Connection to #{env['database']}, :user => #{env['username']}, :password => #{env['password']}, :host => 'localhost' failed",e)
    end
  end
  
end