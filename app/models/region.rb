class Region < ApplicationRecord
  include HasOwners
  has_many :departments
  validates_presence_of :iso_code
  validates_presence_of :name
end
