FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { "testing1" }
    password_confirmation { "testing1" }
    confirmed_at          { Time.now }

    description { Faker::Lorem.sentences(rand(5) + 5).join " " }

    trait :verified do
      verified true
    end

    trait :unverified do
      verified false
    end

    factory :verified_user,   traits: [ :verified ]
    factory :unverified_user, traits: [ :unverified ]
  end
end
