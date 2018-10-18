class Resources
 attr_accessor :name, :sname, :email
end

class ResourcesController < ApplicationController
  def index
    filename = Rails.root.join('config/pages-data/resources.yml')
    file_content = File.read(filename)
    @resources = YAML.safe_load(file_content)
  end
end
