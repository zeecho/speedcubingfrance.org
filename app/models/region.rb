class Region < ApplicationRecord
  FRENCH_REGIONS_JSON_PATH = Rails.root.to_s + "/data/regions.json"
  FRENCH_REGIONS = JSON.parse(File.read(FRENCH_REGIONS_JSON_PATH)).freeze
  ALL_REGIONS = [
    FRENCH_REGIONS.map do |region|
      { code: region["code"], name: region["name"] }
    end
  ].flatten.map { |r| Region.new(r) }.freeze

  has_many :departments
  validates_presence_of :code
  validates_presence_of :name
end
