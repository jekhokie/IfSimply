class ClubsUsers < ActiveRecord::Base
  attr_accessible :type

  belongs_to :club
  belongs_to :user

  validates_inclusion_of :level,      :in => [ "basic", "pro" ]
  validates_inclusion_of :pro_status, :in => [ "ACTIVE", "INACTIVE", "FAILED_PAYMENT", "FAILED_PREAPPROVAL" ]

  scope :paying, -> { where(:level => "pro", :pro_status => "ACTIVE") }

  def within_trial_period?
    Date.today < anniversary_date
  end
end
