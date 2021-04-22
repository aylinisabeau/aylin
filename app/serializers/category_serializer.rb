class CategorySerializer < ApplicationSerializer
  attributes :id, :name, :active_status, :description, :created_at, :updated_at
end
