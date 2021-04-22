FactoryBot.define do
  factory :user do
    name { "MyString" }
    sequence(:email) { |n| "email#{n}" }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
