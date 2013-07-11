FactoryGirl.define do
  factory :club do
    user

    name        { Faker::Lorem.words(2).join " " }
    sub_heading { Faker::Lorem.words(2).join " " }
    description { Faker::Lorem.sentence }
    price_cents { rand(9000) + 1000 }
  end
end
