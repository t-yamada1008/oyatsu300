FactoryBot.define do
  factory :oyatsu do
    sequence(:name, 'oyatsu_1')
    price { '10' }

    trait :y50 do
      price { '50' }
    end

    trait :y100 do
      price { '100' }
    end

    trait :y150 do
      price { '150' }
    end

    trait :y200 do
      price { '200' }
    end

    trait :y250 do
      price { '250' }
    end

    trait :y300 do
      price { '300' }
    end
  end
end
