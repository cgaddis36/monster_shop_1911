FactoryBot.define do
  factory :random_order, class: Order do
    name {Faker::FunnyName.name}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip_code}
  end
end
