class VoteAnswer < ApplicationRecord
  belongs_to :user
  validates_presence_of :user
  belongs_to :vote_option
  validates_presence_of :vote_option
end
