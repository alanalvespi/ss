class PoliciesController < ApplicationController
  # GET /policies
  # GET /policies.json
  def index
    @policies = Policies.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @policies }
    end
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @policy = Policies.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/new
  # GET /policies/new.json
  def new
    @policy = Policies.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/1/edit
  def edit
    @policy = Policies.find(params[:id])
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policies.new(params[:policy])

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policies was successfully created.' }
        format.json { render json: @policy, status: :created, location: @policy }
      else
        format.html { render action: "new" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /policies/1
  # PUT /policies/1.json
  def update
    @policy = Policies.find(params[:id])

    respond_to do |format|
      if @policy.update_attributes(params[:policy])
        format.html { redirect_to @policy, notice: 'Policies was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy = Policies.find(params[:id])
    @policy.destroy

    respond_to do |format|
      format.html { redirect_to policies_index_url }
      format.json { head :no_content }
    end
  end
end
