class ExternalResourcesController < ApplicationController
  before_action :set_external_resource, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]

  # GET /external_resources
  # GET /external_resources.json
  def index
    @external_resources = ExternalResource.all
  end

  # GET /external_resources/new
  def new
    @external_resource = ExternalResource.new
  end

  # GET /external_resources/1/edit
  def edit
  end

  # POST /external_resources
  # POST /external_resources.json
  def create
    @external_resource = ExternalResource.new(external_resource_params)

    respond_to do |format|
      if @external_resource.save
        format.html { redirect_to action: "index", notice: 'External resource was successfully created.' }
        format.json { render :index, status: :created, location: @external_resource }
      else
        format.html { render :new }
        format.json { render json: @external_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_resources/1
  # PATCH/PUT /external_resources/1.json
  def update
    respond_to do |format|
      if @external_resource.update(external_resource_params)
        format.html { redirect_to action: "index", notice: 'External resource was successfully updated.' }
        format.json { render :index, status: :ok, location: @external_resource }
      else
        format.html { render :edit }
        format.json { render json: @external_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_resources/1
  # DELETE /external_resources/1.json
  def destroy
    @external_resource.destroy
    respond_to do |format|
      format.html { redirect_to external_resources_url, notice: 'External resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_resource
      @external_resource = ExternalResource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_resource_params
      params.require(:external_resource).permit(:name, :link, :description, :img)
    end
end
