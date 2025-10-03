FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
    creator { association(:user) }
    geom { FACTORY_GEOM.point(1.20, 39.23) }
  end
end