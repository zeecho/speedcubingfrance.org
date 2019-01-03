class Department < ApplicationRecord
  belongs_to :region
  has_many :clubs

  validates_presence_of :code, allow_blank: false
  validates_presence_of :name, allow_blank: false
  validates_presence_of :region, allow_blank: false
end
