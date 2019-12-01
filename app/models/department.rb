class Department < ApplicationRecord
  include Cachable
  belongs_to :region
  has_many :clubs

  validates_presence_of :code, allow_blank: false
  validates_presence_of :name, allow_blank: false
  validates_presence_of :region, allow_blank: false

  FRENCH_DEPARTMENTS_JSON_PATH = Rails.root.to_s + "/data/departments.json"
  FRENCH_DEPARTMENTS = JSON.parse(File.read(FRENCH_DEPARTMENTS_JSON_PATH)).freeze
  ALL_DEPARTMENTS = [
    FRENCH_DEPARTMENTS.map do |dep|
      { code: dep["code"], name: dep["name"], region: Region.find_by(code: dep["region_code"]) }
    end
  ].flatten.map { |d| Department.new(d) }.freeze

  def self.find_by_code(code)
    c_all_by_id.values.select { |c| c.code == code }.first
  end

  def region
    Region.c_find!(region_id)
  end
end
