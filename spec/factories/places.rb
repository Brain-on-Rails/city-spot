FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    creator { association(:user) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end