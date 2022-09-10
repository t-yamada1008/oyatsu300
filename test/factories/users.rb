FactoryBot.define do
  factory :user do
    sequence(:name, 'test_1')
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 0 }
  end
end
