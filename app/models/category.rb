class Category < ApplicationRecord
  enum active_status: [:inactive, :active]
  has_many :products

  validates :name, presence: true, uniqueness: true


  def something
    binding.pry

    return "10"
  end
end
