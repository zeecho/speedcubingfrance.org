class VoteOption < ApplicationRecord
  belongs_to :vote
  validates_presence_of :vote
  validates_presence_of :name
  has_many :vote_answers, dependent: :destroy, inverse_of: :vote_option

  def answer_for_user(user)
    vote_answers.where(user: user).first
  end
end
