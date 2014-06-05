FactoryGirl.define do
  factory :club do
    user

    name                 { Faker::Lorem.words(1).first }
    sub_heading          { Faker::Lorem.words(1).first }
    description          { Faker::Lorem.sentence }
    price_cents          { rand(9000) + 1000 }
    free_content         { true }
    courses_heading      { Faker::Lorem.words(1).first[0...Settings[:clubs].courses_heading_max_length] }
    articles_heading     { Faker::Lorem.words(1).first[0...Settings[:clubs].articles_heading_max_length] }
    discussions_heading  { Faker::Lorem.words(1).first[0...Settings[:clubs].discussions_heading_max_length] }
    lessons_heading      { Faker::Lorem.words(1).first[0...Settings[:clubs].lessons_heading_max_length] }
  end
end
