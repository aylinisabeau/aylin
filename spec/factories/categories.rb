FactoryBot.define do
  factory :category do
    name { FFaker::Movie.title}
    description {FFaker::Lorem.paragraph}
  end
end
