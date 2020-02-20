FactoryBot.define do
  factory :random_user, class: User do
    name {Faker::FunnyName.name}
    street_address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip_code {Faker::Address.zip_code}
    email {Faker::Internet.email}
    password {password = Faker::Internet.password}
    password_confirmation {password}
  end
end
