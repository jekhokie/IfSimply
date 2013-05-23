class DiscussionBoard < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name,        :presence => { :message => "for discussion board can't be blank" }
  validates :description, :presence => { :message => "for discussion board can't be blank" }

  belongs_to :club

  def user
    club.user
  end

  def assign_defaults
    self.name        = Settings.blogs[:default_name]
    self.description = Settings.blogs[:default_description]
  end
end
