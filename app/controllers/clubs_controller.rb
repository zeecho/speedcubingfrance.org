class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  # GET /clubs
  # GET /clubs.json
  def index
	  @clubs = Club.includes(:department).all.order('departments.name', 'city')
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to clubs_path, flash: { success: 'Club was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    if @club.update(club_params)
      redirect_to clubs_path, flash: { success: 'Club was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    redirect_to clubs_url, flash: { success: 'Club was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def club_params
      params.require(:club).permit(:name, :website, :email, :description, :logo, :department_id, :city)
    end
end
