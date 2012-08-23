class StrategiesMarketsController < ApplicationController
  # GET /strategies_markets
  # GET /strategies_markets.json
  def index
    @strategies_markets = StrategiesMarkets.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @strategies_markets }
    end
  end

  # GET /strategies_markets/1
  # GET /strategies_markets/1.json
  def show
    @strategies_market = StrategiesMarkets.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategies_market }
    end
  end

  # GET /strategies_markets/new
  # GET /strategies_markets/new.json
  def new
    @strategies_market = StrategiesMarkets.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @strategies_market }
    end
  end

  # GET /strategies_markets/1/edit
  def edit
    @strategies_market = StrategiesMarkets.find(params[:id])
  end

  # POST /strategies_markets
  # POST /strategies_markets.json
  def create
    @strategies_market = StrategiesMarkets.new(params[:strategies_market])

    respond_to do |format|
      if @strategies_market.save
        format.html { redirect_to @strategies_market, notice: 'Strategies markets was successfully created.' }
        format.json { render json: @strategies_market, status: :created, location: @strategies_market }
      else
        format.html { render action: "new" }
        format.json { render json: @strategies_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /strategies_markets/1
  # PUT /strategies_markets/1.json
  def update
    @strategies_market = StrategiesMarkets.find(params[:id])

    respond_to do |format|
      if @strategies_market.update_attributes(params[:strategies_market])
        format.html { redirect_to @strategies_market, notice: 'Strategies markets was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @strategies_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategies_markets/1
  # DELETE /strategies_markets/1.json
  def destroy
    @strategies_market = StrategiesMarkets.find(params[:id])
    @strategies_market.destroy

    respond_to do |format|
      format.html { redirect_to strategies_markets_index_url }
      format.json { head :no_content }
    end
  end
end
