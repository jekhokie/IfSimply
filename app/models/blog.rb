class Blog < ActiveRecord::Base
  attr_accessible :content, :image, :title

  validates :title,   :presence => { :message => "for blog can't be blank" }
  validates :content, :presence => { :message => "for blog can't be blank" }

  belongs_to :club

  def user
    club.user
  end

  def assign_defaults
    self.title   = Settings.blogs[:default_title]
    self.content = Settings.blogs[:default_content]
  end
end
