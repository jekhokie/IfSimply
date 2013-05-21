FactoryGirl.define do
  factory :blog do
    club

    title   { Faker::Lorem.words(rand(3) + 3).join " " }
    content { Faker::Lorem.sentences(rand(10) + 5).join " " }
  end
end
