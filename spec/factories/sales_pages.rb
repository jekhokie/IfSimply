# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sales_page do
    club

    heading        { Faker::Lorem.words(rand(3) + 3).join " " }
    sub_heading    { Faker::Lorem.words(rand(5) + 3).join " " }
    call_to_action { Faker::Lorem.words(rand(3) + 1).join " " }
  end
end
