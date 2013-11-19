class Course < ActiveRecord::Base
  attr_accessible :description, :logo, :title

  acts_as_list :scope => :club

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :description, :presence => { :message => "for course can't be blank" }
  validates :club_id,     :presence => true

  belongs_to :club

  has_many :lessons, :dependent => :destroy

  def user
    club.user
  end

  def assign_defaults
    self.title       = Settings.courses[:default_title]
    self.description = Settings.courses[:default_description]
    self.logo        = Settings.courses[:default_logo]
  end
end
