FactoryBot.define do
  factory :ensoku do
    user
    purse { 290 }
    sequence(:comment) { |n| "comment_#{n}" }
    status { 0 }
  end

  trait :not_published do
    status { 1 }
  end

  trait :published do
    status { 2 }
  end
end
