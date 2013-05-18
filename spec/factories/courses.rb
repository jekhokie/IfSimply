# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    club

    title       { Faker::Lorem.words(rand(3) + 3).join " " }
    description { Faker::Lorem.sentences(rand(10) + 5).join " " }
  end
end
