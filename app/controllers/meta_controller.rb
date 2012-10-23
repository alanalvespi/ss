class MetaController < ApplicationController
  # GET /meta
  # GET /meta.json
  def index
    @meta = Meta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meta }
    end
  end

  # GET /meta/name
  # GET /meta/name.json
  def show
    @tablename = params[:id]
    @routename = @tablename.pluralize 
    @meta = Meta.find(@tablename)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meta }
      format.text  { render template: 'meta/show.as.erb' }
    end
    t = "xyz"
  end
end
