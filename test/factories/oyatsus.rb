FactoryBot.define do
  factory :oyatsu do
    sequence(:name, 'oyatsu_1')
    price { '10' }
  end
end
