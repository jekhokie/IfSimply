FactoryGirl.define do
  factory :sales_page do
    club

    benefit1       { Faker::Lorem.words(rand(5) + 1).join " " }
    benefit2       { Faker::Lorem.words(rand(5) + 1).join " " }
    benefit3       { Faker::Lorem.words(rand(5) + 1).join " " }
    details        { Faker::Lorem.words(rand(5) + 1).join " " }
    call_to_action { Faker::Lorem.words(rand(3) + 1).join " " }
    heading        { Faker::Lorem.words(rand(3) + 3).join " " }
    sub_heading    { Faker::Lorem.words(rand(5) + 3).join " " }
    video          { "http://www.ifsimply.com/" }
  end
end
