class Club < ApplicationRecord
  include HasOwners
  belongs_to :department
end
