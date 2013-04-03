FactoryGirl.define do
  factory :club do
    user

    name        { Faker::Lorem.words(rand(3) + 1).join " " }
    description { Faker::Lorem.sentence }
    price_cents { rand(9000) + 1000 }
    logo        { "public/isDefault.jpg" }
  end
end
