class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, uniqueness: true
  validates_numericality_of :price, greater_than: 0

  enum active_status: [:inactive, :active]
end
