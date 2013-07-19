require 'spec_helper'

describe ClubsUsers do
  it { should belong_to :club }
  it { should belong_to :user }

  it { should ensure_inclusion_of(:level).in_array [ :basic, :pro ] }

  it "can be instantiated" do
    ClubsUsers.new.should be_an_instance_of(ClubsUsers)
  end
end