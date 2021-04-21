class ProductSerializer < ApplicationSerializer
  attributes :id, :name, :category_id, :active_status, :price, :created_at, :updated_at

  belongs_to :category
end
