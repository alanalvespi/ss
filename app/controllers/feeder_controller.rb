class FeederController < ApplicationController

require 'find'

  # GET /feeder/market_update
  # GET /feeder/market_update.json
  # GET /feeder/market_update.xml
  def show
    # tmp = Dir.getwd  directory is ss (root of project)
    directory_config =  
      {'market_update' => 'public/data/feeders/market_update',
       'client_update' => 'public/data/feeders/client_update',
       'loadfunds'     => 'public/data/feeders/loadfunds',
      }
    drop_dirs = {
      'public'        => 1,
      'data'          => 1,
      'feeders'       => 1,
      'market_update' => 1,
      'client_update' => 1,
      'loadfunds'     => 1
    }  
    xml  = '<?xml version="1.0" encoding="UTF-8"?>'
    
    raise ActionController::RoutingError.new("Not Found, #{params[:id]}") unless directory_config.has_key?(params[:id])

    
    dir =  directory_config[params[:id]]
      
    @feeder = {'name'=>'data', 'type'=>'dir'}
    
    Find.find(dir) do |path|
      #p "\n>>#{path}::"
      parts = path.split('/')
      t = @feeder
      # travel/make directory structures 
      parts[0..-2].each { |p|
        next unless p
        next if drop_dirs.has_key?(p) 
        t[p] = { 'type' => 'dir', 'name'=>p } unless t.has_key?(p)
        t = t[p]
      }
      
      http_path = path.gsub('public/','')
      atrname = parts[-1]
      atrname = atrname.gsub(".",'') 
      t[atrname] = { 'type'=>'file', "path"=> http_path, "name"=>parts[-1], "size"=>File.size(path), "create"=>File.ctime(path), "modify"=>File.mtime(path) } unless FileTest.directory?(path)
    end
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeder }
      format.xml  { render xml: genxml(@feeder,xml) }
    end
  end

def genxml(t, x ) 
  if (t['type'] == 'file') then
    x = "#{x}\n<file"
    t.keys.each { | k |
      next if k == 'type'
      x = "#{x} #{k}=\"#{t[k]}\"" 
    }
    return "#{x} />"
  end
  
  # Here a Directory
  x = "#{x}\n<dir name=\"#{t['name']}\">"
  t.keys.each { |s|
    next if s == 'name'
    next if s == 'type'
    x = genxml(t[s],x)  
  }
  return "#{x}\n</dir>"
  
  end


  # Get /feeder/start/market_update
  
  def start
    batch_name = params[:id]
    valuta     = nil
    valuta     = params[:valuta] if params.has_key?(:valuta)
    
    @feeder = Feeder.new(batch_name,valuta)
    
    redirect_to @feeder.logfilename
    

  end
  
  def client_upload
    name =  'RL360_Daily.CSV'
    directory = "feeders/client_update/data/"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(params[:Filedata].read) }
    print "File uploaded..."
    
    # Today 
    as_of = Date.today
    
    day   = "%02d" % as_of.day
    month = "%02d" % as_of.month
    year  = "%4d" % as_of.year
    
    #redirect_to("/data/feeders/client_update/2012/09/03/RL360ClientUpdate_log.txt_log.txt")
    redirect_to("/data/feeders/client_update/#{year}-#{month}-#{day}/RL360ClientUpdate_log.txt")
  end
  
  
end
