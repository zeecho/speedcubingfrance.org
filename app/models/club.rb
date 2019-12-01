class Club < ApplicationRecord
  include Cachable
  belongs_to :department

  validates_presence_of :name
  validates_presence_of :description
  validates :website, :format => URI::regexp(%w(http https)), :allow_blank => true
  validates :logo, :format => URI::regexp(%w(http https)), :allow_blank => true

  def department
    Department.c_find!(department_id)
  end
end
