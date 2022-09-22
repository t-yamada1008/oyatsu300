FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 0 }
  end
end
