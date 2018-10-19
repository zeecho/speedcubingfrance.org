class ExternalResource < ApplicationRecord
  validate_presence_of :name
  validate_presence_of :description
  validates :link, :format => URI::regexp(%w(http https))
  validates :img, :format => URI::regexp(%w(http https))
end
