class ExternalResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :redirect_unless_comm!, except: [:index]
  before_action :set_external_resource, only: [:edit, :update, :destroy]
  before_action :set_existing_resources, only: [:edit, :update]

  # GET /external_resources
  # GET /external_resources.json
  def index
    @external_resources = ExternalResource.all.order(:rank)
  end

  # GET /external_resources/new
  def new
    @external_resource = ExternalResource.new
    @external_resource.rank = -1
    set_existing_resources
  end

  # GET /external_resources/1/edit
  def edit
  end

  # POST /external_resources
  def create
    @external_resource = ExternalResource.new(external_resource_params)
      if @external_resource.save
        redirect_to external_resources_path, flash: { success: 'External resource was successfully created.' }
      else
        render :new
      end
  end

  # PATCH/PUT /external_resources/1
  # PATCH/PUT /external_resources/1.json
  def update
      if @external_resource.update(external_resource_params)
        redirect_to external_resources_path, flash: { success: 'External resource was successfully updated.' }
      else
        render :edit
      end
  end

  # DELETE /external_resources/1
  # DELETE /external_resources/1.json
  def destroy
    @external_resource.destroy
    redirect_to external_resources_url, flash: { success: 'External resource was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_resource
      @external_resource = ExternalResource.find(params[:id])
    end

    def set_existing_resources
      @existing_resources = ExternalResource.order(:rank).collect { |er| ['après ' + er.name, er.rank + 1] }
      @existing_resources.unshift(['en première position', 1])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_resource_params
      params.require(:external_resource).permit(:name, :link, :description, :img, :rank)
    end
end
