FactoryGirl.define do
  factory :topic do
    discussion_board

    subject     { Faker::Lorem.words(rand(3) + 3).join " " }
    description { Faker::Lorem.sentences(rand(10) + 5).join " " }
  end
end
