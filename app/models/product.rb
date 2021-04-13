class Product < ApplicationRecord
  include Activable
  belongs_to :category

  validates :name, presence: true, uniqueness: true
  validates_numericality_of :price, greater_than: 0

end
