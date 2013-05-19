class Course < ActiveRecord::Base
  attr_accessible :description, :title

  validates :title,       :presence => true
  validates :description, :presence => true
  validates :club_id,     :presence => true

  belongs_to :club

  def assign_defaults
    self.title       = Settings.courses[:default_title]
    self.description = Settings.courses[:default_description]
  end
end
