class Category < ApplicationRecord
  include Activable
  has_many :products

  validates :name, presence: true, uniqueness: true

end
