class RegionsController < ApplicationController
  before_action :redirect_unless_comm!
  before_action :set_region, only: [:show, :edit, :update, :destroy]

  # GET /regions
  def index
    @regions = Region.all
  end

  # GET /regions/1
  def show
  end

  # GET /regions/new
  def new
    @region = Region.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions
  def create
    @region = Region.new(region_params)

    if @region.save
      redirect_to @region, flash: { success: 'Region was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /regions/1
  def update
    if @region.update(region_params)
      redirect_to @region, flash: { success: 'Region was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /regions/1
  def destroy
    @region.destroy
    redirect_to regions_url, flash: { success: 'Region was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:iso_code, :name)
    end
end
