FactoryGirl.define do
  factory :sales_page do
    club

    heading        { Faker::Lorem.words(rand(3) + 3).join " " }
    sub_heading    { Faker::Lorem.words(rand(5) + 3).join " " }
    call_to_action { Faker::Lorem.words(rand(3) + 1).join " " }
    video          { "http://www.google.com/" }
  end
end
