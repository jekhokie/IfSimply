FactoryGirl.define do
  factory :club do
    user

    name         { Faker::Lorem.words(1).first }
    sub_heading  { Faker::Lorem.words(1).first }
    description  { Faker::Lorem.sentence }
    price_cents  { rand(9000) + 1000 }
    free_content { [ true, false ].sample }
  end
end
