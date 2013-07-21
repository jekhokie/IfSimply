FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { "testing1" }
    password_confirmation { "testing1" }
    confirmed_at          { Time.now }

    description { Faker::Lorem.sentences(rand(5) + 5).join " " }
  end
end
