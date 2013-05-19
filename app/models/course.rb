class Course < ActiveRecord::Base
  attr_accessible :description, :title

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :description, :presence => { :message => "for course can't be blank" }
  validates :club_id,     :presence => true

  belongs_to :club

  has_many :lessons, :dependent => :destroy

  def assign_defaults
    self.title       = Settings.courses[:default_title]
    self.description = Settings.courses[:default_description]
  end
end
