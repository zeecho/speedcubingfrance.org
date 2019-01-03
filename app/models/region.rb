class Region < ApplicationRecord
  has_many :departments
  validates_presence_of :code
  validates_presence_of :name
end
