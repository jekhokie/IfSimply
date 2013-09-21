FactoryGirl.define do
  factory :subscription, :class => 'ClubsUsers' do
    user
    club

    level { :basic }
  end
end
