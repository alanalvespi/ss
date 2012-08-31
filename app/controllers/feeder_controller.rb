class FeederController < ApplicationController

require 'find'

  # GET /feeders/market_update
  # GET /clients/market_update.json
  # GET /clients/market_update.xml
  def show
    directory_config =  
      {'market_update'=>'../feeders/market_update/data',
      'client_update'=>'../feeders/market_update/data',
      'load_funds'   =>'../feeders/load_funds/data',
      }
      
    tmp = Dir.getwd
    dir =  directory_config[params[:id]]
    @feeder = {}
    Find.find(dir) do |path|
      #p "\n>>#{path}::"
      parts = path.split('/')
      t = @feeder
      # travel/make directory structures 
      parts[0..-2].each { |p|
        next unless p
        #p "[#{p}]" 
        p = "_#{p}" if p.to_i
        t[p] = {} unless t.has_key?(p)
        t = t[p]
      }
    
      t[parts[-1]] = { "path"=> path, "name"=>parts[-1], "size"=>File.size(path), "create"=>File.ctime(path), "modify"=>File.mtime(path) } unless FileTest.directory?(path)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feeder }
      format.xml { render xml: @feeder }
    end
  end



end
