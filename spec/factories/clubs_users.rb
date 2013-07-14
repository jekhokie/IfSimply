FactoryGirl.define do
  factory :subscription, :class => 'ClubsUsers' do
    user
    club

    level { [ :basic, :pro ][rand(2)] }
  end
end
