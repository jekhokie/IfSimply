FactoryGirl.define do
  factory :club do
    user

    name                 { Faker::Lorem.words(1).first }
    sub_heading          { Faker::Lorem.words(1).first }
    description          { Faker::Lorem.sentence }
    price_cents          { rand(9000) + 1000 }
    free_content         { true }
    courses_heading      { Faker::Lorem.words(1).first }
    articles_heading     { Faker::Lorem.words(1).first }
    discussions_heading  { Faker::Lorem.words(1).first }
  end
end
