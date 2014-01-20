class Course < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [ :slugged, :history ]

  attr_accessible :description, :logo, :title

  acts_as_list :scope => :club

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :description, :presence => { :message => "for course can't be blank" }
  validates :club_id,     :presence => true

  belongs_to :club

  has_many :lessons, :dependent => :destroy

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :description, :presence => { :message => "for course can't be blank" }
  validates :club_id,     :presence => true

  def user
    club.user
  end

  def assign_defaults
    self.title       = Settings.courses[:default_title]
    self.description = Settings.courses[:default_description]

    if self.club.courses.empty?
      self.logo = Settings.courses[:default_initial_logo]
    else
      self.logo = Settings.courses[:default_logo]
    end
  end

  private

  def should_generate_new_friendly_id?
    true
  end
end
