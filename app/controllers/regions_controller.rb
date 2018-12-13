class RegionsController < ApplicationController
  before_action :redirect_unless_admin!

  REGIONS_FILE = "#{Rails.root}/data/regions.json"
  DEPARTMENTS_FILE = "#{Rails.root}/data/departments.json"

  def import
    if Region.all.empty?
      regions_content = File.read(REGIONS_FILE)
      regions = JSON.parse(regions_content)
      regions.each do |value|
        value.delete('id')
        value.delete('slug')
      end
      Region.create(regions)

      if Department.all.empty?
        departments_content = File.read(DEPARTMENTS_FILE)
        departments_source = JSON.parse(departments_content)
        departments_source.each do |value|
          department = Department.new
          department.code = value["code"]
          department.name = value["name"]
          department.region = Region.find_by(code: value["region_code"])
          department.save
        end
      end
      flash[:success] = 'Regions and departments have been imported'
    else
      flash[:warning] = 'Regions and departments have already been imported'
    end

    render :import
  end
end
