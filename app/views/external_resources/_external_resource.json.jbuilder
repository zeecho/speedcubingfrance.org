json.extract! external_resource, :id, :name, :link, :description, :img, :created_at, :updated_at
json.url external_resource_url(external_resource, format: :json)
