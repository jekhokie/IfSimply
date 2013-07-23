FactoryGirl.define do
  factory :post do
    topic

    user_id { topic.poster.id }
    content { Faker::Lorem.sentences(rand(10) + 5).join " " }
  end
end
