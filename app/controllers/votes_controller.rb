class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :redirect_unless_vote_manager!, except: [:show, :answer]
  before_action :set_vote, only: [:show, :edit, :update, :destroy, :answer, :clear_answers]
  before_action :redirect_unless_can_vote!, only: [:answer]

  # GET /votes
  def index
    @votes = Vote.all
  end

  # GET /votes/1
  def show
  end

  # GET /votes/new
  def new
    @vote = Vote.new
  end

  # GET /votes/1/edit
  def edit
  end

  # POST /votes
  def create
    @vote = Vote.new(vote_params)
    if @vote.save
      redirect_to @vote, notice: 'Vote was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /votes/1
  def update
    if @vote.update(vote_params)
      redirect_to @vote, notice: 'Vote was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /votes/1
  def destroy
    @vote.destroy
    redirect_to votes_url, notice: 'Vote was successfully destroyed.'
  end

  def answer
    @user = current_user
    answers = params[:vote_answer] || {}
    answers = answers[:vote_options] || []
    answers = @vote.vote_options.where(id: answers)
    if answers.blank?
      return redirect_to @vote, flash: { danger: I18n.t("votes.notif.no_valid_answers") }
    end
    if !@vote.multiple_choices && answers.size > 1
      return redirect_to @vote, flash: { danger: I18n.t("votes.notif.too_many_answers") }
    end
    # TODO this is temporary (for french cup vote). We need to either make this an option or just purely revert it in one month
    if answers.size != 8
      return redirect_to @vote, flash: { danger: "Vous devez choisir exactement 8 réponses" }
    end

    @user.with_lock do
      @vote.answers_for_user(@user).delete_all
      answers.each do |a|
        VoteAnswer.create!(user: @user, vote_option: a)
      end
    end
    redirect_to @vote, flash: { success: I18n.t("votes.notif.answer_saved") }
  end

  def clear_answers
    VoteAnswer.where(id: @vote.vote_answers.map(&:id)).delete_all
    redirect_to edit_vote_path(@vote), flash: { success: "Vote answers cleared." }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find_by_id(params[:id]) || Vote.find_by_id(params[:vote_id])
      unless @vote&.user_can_view?(current_user)
        raise ActiveRecord::RecordNotFound.new("Not Found")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:vote).permit(
        :name,
        :visible,
        :over,
        # Note: I know these should be removed from permitted params when the
        # vote has answers. But it's used only by responsible people, so they
        # will blame themselves if they do unreasonable things :p
        :multiple_choices,
        vote_options_attributes: [:name, :id, :_destroy],
      )
    end

    def redirect_unless_vote_manager!
      unless current_user&.can_manage_vote_matters?
        redirect_to root_url, :alert => I18n.t("users.no_rights.votes")
      end
    end

    def redirect_unless_can_vote!
      unless @vote.user_can_vote?(current_user)
        redirect_to root_url, :alert => "Vous devez avoir un ID WCA pour pouvoir voter"
      end
    end
end
