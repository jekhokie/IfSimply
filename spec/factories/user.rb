FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { "testing1" }
    password_confirmation { "testing1" }
  end
end
