class PlantypeStrategiesController < ApplicationController
  # GET /plantype_strategies
  # GET /plantype_strategies.json
  def index
    @plantype_strategies = PlantypeStrategy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plantype_strategies }
    end
  end

  # GET /plantype_strategies/1
  # GET /plantype_strategies/1.json
  def show
    @plantype_strategy = PlantypeStrategy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plantype_strategy }
    end
  end

  # GET /plantype_strategies/new
  # GET /plantype_strategies/new.json
  def new
    @plantype_strategy = PlantypeStrategy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plantype_strategy }
    end
  end

  # GET /plantype_strategies/1/edit
  def edit
    @plantype_strategy = PlantypeStrategy.find(params[:id])
  end

  # POST /plantype_strategies
  # POST /plantype_strategies.json
  def create
    @plantype_strategy = PlantypeStrategy.new(params[:plantype_strategy])

    respond_to do |format|
      if @plantype_strategy.save
        format.html { redirect_to @plantype_strategy, notice: 'Plantype strategy was successfully created.' }
        format.json { render json: @plantype_strategy, status: :created, location: @plantype_strategy }
      else
        format.html { render action: "new" }
        format.json { render json: @plantype_strategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plantype_strategies/1
  # PUT /plantype_strategies/1.json
  def update
    @plantype_strategy = PlantypeStrategy.find(params[:id])

    respond_to do |format|
      if @plantype_strategy.update_attributes(params[:plantype_strategy])
        format.html { redirect_to @plantype_strategy, notice: 'Plantype strategy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plantype_strategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plantype_strategies/1
  # DELETE /plantype_strategies/1.json
  def destroy
    @plantype_strategy = PlantypeStrategy.find(params[:id])
    @plantype_strategy.destroy

    respond_to do |format|
      format.html { redirect_to plantype_strategies_url }
      format.json { head :no_content }
    end
  end
end
