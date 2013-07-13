FactoryGirl.define do
  factory :clubs_user, :class => 'ClubsUsers' do
    level { [ :basic, :pro ][rand(2)] }
  end
end
