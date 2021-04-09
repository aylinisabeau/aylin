class Category < ApplicationRecord
  enum active_status: [:inactive, :active]

  def something
    binding.pry

    return "10"
  end
end
