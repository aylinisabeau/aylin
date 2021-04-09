FactoryBot.define do
  factory :product do
    name { FFaker::AnimalUS.common_name }
    category { build(:category) }
    price { "9.99" }
  end
end
