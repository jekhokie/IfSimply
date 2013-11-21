FactoryGirl.define do
  factory :upsell_page do
    heading                 { Faker::Lorem.words(rand(5) + 1).join " " }
    sub_heading             { Faker::Lorem.words(rand(5) + 1).join " " }
    basic_articles_desc     { Faker::Lorem.words(rand(5) + 1).join " " }
    exclusive_articles_desc { Faker::Lorem.words(rand(5) + 1).join " " }
    basic_courses_desc      { Faker::Lorem.words(rand(5) + 1).join " " }
    in_depth_courses_desc   { Faker::Lorem.words(rand(5) + 1).join " " }
    discussion_forums_desc  { Faker::Lorem.words(rand(5) + 1).join " " }
  end
end
