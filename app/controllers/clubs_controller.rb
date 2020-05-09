class ClubsController < ApplicationController
  before_action :redirect_unless_comm!, except: [:index, :show]
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.includes(:department).all.order('departments.name', 'city')
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
      redirect_to clubs_path, flash: { success: I18n.t("clubs.notif.create") }
    else
      render :new
    end
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    if @club.update(club_params)
      redirect_to clubs_path, flash: { success: I18n.t("clubs.notif.update") }
    else
      render :edit
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    redirect_to clubs_url, flash: { success: I18n.t("clubs.notif.destroy") }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def club_params
      params.require(:club).permit(:name, :website, :email, :facebook, :description, :logo, :department_id, :city)
    end
end
