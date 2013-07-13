class ClubsUsers < ActiveRecord::Base
  attr_accessible :type

  belongs_to :club
  belongs_to :user

  validates_inclusion_of :type, :in => [ :basic, :pro ]
end
