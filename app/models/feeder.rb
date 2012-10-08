class Feeder
  # Simple Ruby class to execute the external Feeders...
  attr_accessor :valuta, :batch_name, :config, :cmdline, :logfilename

  @@configuration  = {
      'market_update' => {
        'execdir'     => "feeders/market_update",
        'pgm'         => 'DailyMarketUpdate.rb',
        'logfile'     => 'DailyMarketUpdate_log.txt',
      },
      'client_update' => {
        'execdir'     => "feeders/client_update",
        'pgm'         => 'RL360ClientUpdate.rb',
        'logfile'     => 'RL360ClientUpdate_log.txt',
      },
      'loadfunds' => {
        'execdir'     => "feeders/loadfunds",
        'pgm'         => 'RL360_loadfunds.rb',
        'logfile'     => 'RL360_loadfunds_log.txt',
      }
    }
    
    def initialize(name,v=nil)
            
      # parameters
      @batch_name = name
      @as_of = Date.today 
      
      if (v) then
        @valuta = v 
        @as_of = Date.parse(@valuta)   
      end
      
      
      # get database Access parms...
  
      env = Rails.env
      db_conf = Ss::Application.config.database_configuration[env]
      @config = @@configuration[@batch_name]
      
      @config['database']    = db_conf['database']
      @config['user']        = db_conf['username']
      @config['password']    = db_conf['password']
      @config['host']        = db_conf['host']
      @config['port']        = db_conf['port']

      @config['host'] = 'localhost' unless @config['host']
      @config['port'] = '3306'      unless @config['port']
    
      # Valuta Date      
      day   = "%02d" % @as_of.day
      month = "%02d" % @as_of.month
      year  = "%4d"  % @as_of.year


      case @batch_name
        
      when 'market_update'
        @cmdline = "bundle exec ruby -W0 -C#{@config['execdir']} #{@config['pgm']} valuta=#{@valuta} database=#{@config['database']} username=#{@config['user']} password=#{@config['password']} host=#{@config['host']} port=#{@config['port']}"
        puts "About to execute <#{@cmdline}>"
        result = system(@cmdline)
        @logfilename = "/data/feeders/market_update/#{year}/#{month}/#{day}/market_update_log.txt"
  
      when 'client_update'
        @cmdline = "bundle exec ruby -W0 -C#{@config['execdir']} #{@config['pgm']} database=#{@config['database']} username=#{@config['user']} password=#{@config['password']} host=#{@config['host']} port=#{@config['port']}"
        puts "About to execute <#{@cmdline}>"
        result = system(@cmdline)
        @logfilename = "/data/feeders/client_update/#{year}/#{month}/#{day}/client_update_log.txt"
        
      when 'loadfunds'
        @cmdline = "bundle exec ruby -W0 -C#{@config['execdir']} #{@config['pgm']} database=#{@config['database']} username=#{@config['user']} password=#{@config['password']} host=#{@config['host']} port=#{@config['port']}"
        puts "About to execute <#{@cmdline}>"
        result = system(@cmdline)
        @logfilename = "/data/feeders/loadfunds/#{year}/#{month}/#{day}/RL360loadfunds_log.txt"
      end
      
      return result
    end

end
