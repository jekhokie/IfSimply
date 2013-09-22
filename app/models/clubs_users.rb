class ClubsUsers < ActiveRecord::Base
  attr_accessible :type

  belongs_to :club
  belongs_to :user

  validates_inclusion_of :level, :in => [ "basic", "pro" ]

  scope :paying, -> { where(:level => "pro", :pro_active => true) }
end
