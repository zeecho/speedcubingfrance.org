class Vote < ApplicationRecord
  has_many :vote_options, dependent: :destroy, inverse_of: :vote
  has_many :vote_answers, through: :vote_options
  accepts_nested_attributes_for :vote_options, allow_destroy: true

  def answers_for_user(user)
    vote_answers.where(user: user)
  end

  def user_can_view?(user)
    visible || user&.can_manage_vote_matters?
  end

  def user_can_vote?(user)
    # TODO this is temporary (for french cup vote). We need to either make this an option or just purely revert it in one month
    user&.wca_id?
  end
end
