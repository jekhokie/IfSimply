class ClubsUsers < ActiveRecord::Base
  attr_accessible :type

  belongs_to :club
  belongs_to :user

  validates_inclusion_of :level,      :in => [ "basic", "pro" ]
  validates_inclusion_of :pro_status, :in => [ "ACTIVE", "INACTIVE", "FAILED_PAYMENT", "FAILED_PREAPPROVAL", "PRO_CHANGE" ]

  scope :paying, -> { where("level = ? and pro_status != 'INACTIVE'", :pro) }

  def within_trial_period?
    Date.today < anniversary_date
  end
end
