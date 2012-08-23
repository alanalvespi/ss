class PlantypesController < ApplicationController
  # GET /plantypes
  # GET /plantypes.json
  def index
    @plantypes = Plantypes.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plantypes }
    end
  end

  # GET /plantypes/1
  # GET /plantypes/1.json
  def show
    @plantype = Plantypes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plantype }
    end
  end

  # GET /plantypes/new
  # GET /plantypes/new.json
  def new
    @plantype = Plantypes.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plantype }
    end
  end

  # GET /plantypes/1/edit
  def edit
    @plantype = Plantypes.find(params[:id])
  end

  # POST /plantypes
  # POST /plantypes.json
  def create
    @plantype = Plantypes.new(params[:plantype])

    respond_to do |format|
      if @plantype.save
        format.html { redirect_to @plantype, notice: 'Plantypes was successfully created.' }
        format.json { render json: @plantype, status: :created, location: @plantype }
      else
        format.html { render action: "new" }
        format.json { render json: @plantype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plantypes/1
  # PUT /plantypes/1.json
  def update
    @plantype = Plantypes.find(params[:id])

    respond_to do |format|
      if @plantype.update_attributes(params[:plantype])
        format.html { redirect_to @plantype, notice: 'Plantypes was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plantype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plantypes/1
  # DELETE /plantypes/1.json
  def destroy
    @plantype = Plantypes.find(params[:id])
    @plantype.destroy

    respond_to do |format|
      format.html { redirect_to plantypes_index_url }
      format.json { head :no_content }
    end
  end
end
