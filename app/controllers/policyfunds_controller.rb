class PolicyfundsController < ApplicationController
  # GET /policyfunds
  # GET /policyfunds.json
  def index
    @policyfunds = Policyfund.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @policyfunds }
    end
  end

  # GET /policyfunds/1
  # GET /policyfunds/1.json
  def show
    @policyfund = Policyfund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @policyfund }
    end
  end

  # GET /policyfunds/new
  # GET /policyfunds/new.json
  def new
    @policyfund = Policyfund.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @policyfund }
    end
  end

  # GET /policyfunds/1/edit
  def edit
    @policyfund = Policyfund.find(params[:id])
  end

  # POST /policyfunds
  # POST /policyfunds.json
  def create
    @policyfund = Policyfund.new(params[:policyfund])

    respond_to do |format|
      if @policyfund.save
        format.html { redirect_to @policyfund, notice: 'Policyfund was successfully created.' }
        format.json { render json: @policyfund, status: :created, location: @policyfund }
      else
        format.html { render action: "new" }
        format.json { render json: @policyfund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /policyfunds/1
  # PUT /policyfunds/1.json
  def update
    @policyfund = Policyfund.find(params[:id])

    respond_to do |format|
      if @policyfund.update_attributes(params[:policyfund])
        format.html { redirect_to @policyfund, notice: 'Policyfund was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @policyfund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policyfunds/1
  # DELETE /policyfunds/1.json
  def destroy
    @policyfund = Policyfund.find(params[:id])
    @policyfund.destroy

    respond_to do |format|
      format.html { redirect_to policyfunds_url }
      format.json { head :no_content }
    end
  end
end
