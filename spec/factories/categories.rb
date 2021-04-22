FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{FFaker::Movie.title}_#{n}" }
    description {FFaker::Lorem.paragraph}
  end
end
