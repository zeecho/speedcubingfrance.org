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
    user&.has_active_subscription?
  end
end
