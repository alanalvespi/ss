class PlantypefundsController < ApplicationController
  # GET /plantypefunds
  # GET /plantypefunds.json
  def index
    @plantypefunds = Plantypefund.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plantypefunds }
    end
  end

  # GET /plantypefunds/1
  # GET /plantypefunds/1.json
  def show
    @plantypefund = Plantypefund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plantypefund }
    end
  end

  # GET /plantypefunds/new
  # GET /plantypefunds/new.json
  def new
    @plantypefund = Plantypefund.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plantypefund }
    end
  end

  # GET /plantypefunds/1/edit
  def edit
    @plantypefund = Plantypefund.find(params[:id])
  end

  # POST /plantypefunds
  # POST /plantypefunds.json
  def create
    @plantypefund = Plantypefund.new(params[:plantypefund])

    respond_to do |format|
      if @plantypefund.save
        format.html { redirect_to @plantypefund, notice: 'Plantypefund was successfully created.' }
        format.json { render json: @plantypefund, status: :created, location: @plantypefund }
      else
        format.html { render action: "new" }
        format.json { render json: @plantypefund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plantypefunds/1
  # PUT /plantypefunds/1.json
  def update
    @plantypefund = Plantypefund.find(params[:id])

    respond_to do |format|
      if @plantypefund.update_attributes(params[:plantypefund])
        format.html { redirect_to @plantypefund, notice: 'Plantypefund was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plantypefund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plantypefunds/1
  # DELETE /plantypefunds/1.json
  def destroy
    @plantypefund = Plantypefund.find(params[:id])
    @plantypefund.destroy

    respond_to do |format|
      format.html { redirect_to plantypefunds_url }
      format.json { head :no_content }
    end
  end
end
