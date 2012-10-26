class PlantypestrategyfundsController < ApplicationController
  # GET /plantypestrategyfunds
  # GET /plantypestrategyfunds.json
  def index
    @plantypestrategyfunds = Plantypestrategyfund.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plantypestrategyfunds }
    end
  end

  # GET /plantypestrategyfunds/1
  # GET /plantypestrategyfunds/1.json
  def show
    @plantypestrategyfund = Plantypestrategyfund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plantypestrategyfund }
    end
  end

  # GET /plantypestrategyfunds/new
  # GET /plantypestrategyfunds/new.json
  def new
    @plantypestrategyfund = Plantypestrategyfund.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plantypestrategyfund }
    end
  end

  # GET /plantypestrategyfunds/1/edit
  def edit
    @plantypestrategyfund = Plantypestrategyfund.find(params[:id])
  end

  # POST /plantypestrategyfunds
  # POST /plantypestrategyfunds.json
  def create
    @plantypestrategyfund = Plantypestrategyfund.new(params[:plantypestrategyfund])

    respond_to do |format|
      if @plantypestrategyfund.save
        format.html { redirect_to @plantypestrategyfund, notice: 'Plantypestrategyfunds was successfully created.' }
        format.json { render json: @plantypestrategyfund, status: :created, location: @plantypestrategyfund }
      else
        format.html { render action: "new" }
        format.json { render json: @plantypestrategyfund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plantypestrategyfunds/1
  # PUT /plantypestrategyfunds/1.json
  def update
    @plantypestrategyfund = Plantypestrategyfund.find(params[:id])

    respond_to do |format|
      if @plantypestrategyfund.update_attributes(params[:plantypestrategyfund])
        format.html { redirect_to @plantypestrategyfund, notice: 'Plantypestrategyfunds was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plantypestrategyfund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plantypestrategyfunds/1
  # DELETE /plantypestrategyfunds/1.json
  def destroy
    @plantypestrategyfund = Plantypestrategyfund.find(params[:id])
    @plantypestrategyfund.destroy

    respond_to do |format|
      format.html { redirect_to plantypestrategyfunds_index_url }
      format.json { head :no_content }
    end
  end
end
