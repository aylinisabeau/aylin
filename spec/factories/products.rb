FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "nombre#{n}" }
    category { build(:category) }
    price { "9.99" }
  end
end

