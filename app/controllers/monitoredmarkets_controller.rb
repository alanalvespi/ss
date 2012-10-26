class MonitoredmarketsController < ApplicationController
  # GET /mMonitoredmarket
  # GET /mMonitoredmarket.json
  def index
    @Monitoredmarket = Monitoredmarket.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @Monitoredmarket }
    end
  end

  # GET /Monitoredmarket/1
  # GET /Monitoredmarket/1.json
  def show
    @Monitoredmarket = Monitoredmarket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @Monitoredmarket }
    end
  end


  # GET /Monitoredmarket/1/edit
  def edit
    @Monitoredmarket = Monitoredmarket.find(params[:id])
  end

  # POST /Monitoredmarket
  # POST /Monitoredmarket.json
  def create
    @Monitoredmarket = Monitoredmarket.new(params[:Monitoredmarket])

    respond_to do |format|
      if @Monitoredmarket.save
        format.html { redirect_to @Monitoredmarket, notice: 'Monitoredmarket was successfully created.' }
        format.json { render json: @Monitoredmarket, status: :created, location: @Monitoredmarket }
      else
        format.html { render action: "new" }
        format.json { render json: @Monitoredmarket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Monitoredmarket/1
  # PUT /Monitoredmarket/1.json
  def update
    @Monitoredmarket = Monitoredmarket.find(params[:id])

    respond_to do |format|
      if @Monitoredmarket.update_attributes(params[:Monitoredmarket])
        format.html { redirect_to @Monitoredmarket, notice: 'Monitoredmarket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @Monitoredmarket.errors, status: :unprocessable_entity }
      end
    end
  end

end
