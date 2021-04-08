class Category < ApplicationRecord
  enum active_status: [:inactive, :active]
end
