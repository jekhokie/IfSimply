FactoryGirl.define do
  factory :blog do
    club

    title   { Faker::Lorem.words(rand(10) + 5).join " " }
    content { Faker::Lorem.sentences(rand(30) + 5).join " " }
    free    { [ true, false].sample }
  end
end
