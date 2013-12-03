FactoryGirl.define do
  factory :lesson do
    course

    title      { Faker::Lorem.words(rand(3) + 3).join " " }
    background { Faker::Lorem.sentences(rand(10) + 5).join " " }
    video      { "http://vimeo.com/22977143" }
    free       { [ true, false ].sample }
  end
end
