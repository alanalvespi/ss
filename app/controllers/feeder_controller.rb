class FeederController < ApplicationController

require 'find'

  # GET /feeders/market_update
  # GET /clients/market_update.json
  # GET /clients/market_update.xml
  def show
    # tmp = Dir.getwd  directory is ss (root of project)
    directory_config =  
      {'market_update'=>'feeders/market_update/data',
      'client_update'=>'feeders/market_update/data',
      'load_funds'   =>'feeders/load_funds/data',
      }
    drop_dirs = {
      'feeders'       => 1,
      'market_update' => 1,
      'client_update' => 1,
      'loadfunds'     => 1
    }  
    
    dir =  directory_config[params[:id]]
    @feeder = {}
    Find.find(dir) do |path|
      #p "\n>>#{path}::"
      parts = path.split('/')
      t = @feeder
      # travel/make directory structures 
      parts[0..-2].each { |p|
        next unless p
        next if drop_dirs.has_key?(p)
        #p "[#{p}]" 
        p = "_#{p}" if (p.to_i != 0)
        t[p] = {} unless t.has_key?(p)
        t = t[p]
      }
      
      atrname = parts[-1]
      atrname = atrname.gsub(".",'') 
      t[atrname] = { "path"=> path, "name"=>parts[-1], "size"=>File.size(path), "create"=>File.ctime(path), "modify"=>File.mtime(path) } unless FileTest.directory?(path)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeder }
      format.xml { render xml: @feeder }
    end
  end

  # PUT /feeders/market_update
  # PUT /feeders/market_update.json
  def update
    batch_name = params[:id]
    valuta = params[:valuta]
    env = Rails.env
    db_conf = Ss::Application.config.database_configuration[env]

    configuration  = {
      'market_update' => {
        'execdir'     => "feeders/#{batch_name}",
        'pgm'         => 'DailyMarketUpdate.rb',
        'logfile'     => 'DailyMarketUpdate.log',
        'database'    => db_conf['database'],
        'user'        => db_conf['username'],
        'password'    => db_conf['password'],
        'host'        => db_conf['host'],
        'port'        => db_conf['port']
      },
      'client_update' => {
        'execdir'     => "feeders/#{batch_name}",
        'pgm'         => 'RL360ClientUpdate.rb',
        'logfile'     => 'RL360ClientUpdate.log',
        'database'    => db_conf['database'],
        'user'        => db_conf['username'],
        'password'    => db_conf['password'],
        'host'        => db_conf['host'],
        'port'        => db_conf['port']
      },
      'loadfunds' => {
        'execdir'     => "feeders/#{batch_name}",
        'pgm'         => 'RL360_loadfunds.rb',
        'logfile'     => 'RL360_loadfunds.log',
        'database'    => db_conf['database'],
        'user'        => db_conf['username'],
        'password'    => db_conf['password'],
        'host'        => db_conf['host'],
        'port'        => db_conf['port'],
      }
    }
    
    
    c = configuration[batch_name]
    
    c['host'] = 'localhost' unless c['host']
    c['port'] = '3306'      unless c['port']
    
    case batch_name
      
    when 'market_update'
      result = system("bundle exec ruby -C#{c['execdir']} #{c['pgm']} valuta=#{valuta} database=#{c['database']} username=#{c['user']} password=#{c['password']} host=#{c['host']} port=#{c['port']}")
      
    when 'client_update'
      result = system("bundle exec ruby -C#{c['execdir']} #{c['pgm']} database=#{c['database']} username=#{c['user']} password=#{c['password']} host=#{c['host']} port=#{c['port']}")
      
    when 'loadfunds'
      result = system("bundle exec ruby -C#{c['execdir']} #{c['pgm']} database=#{c['database']} username=#{c['user']} password=#{c['password']} host=#{c['host']} port=#{c['port']}")

    end
    
    @feeder = "#{batch_name} Execution Started"     
  end
end