class Lesson < ActiveRecord::Base
  attr_accessible :background, :title

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :background,  :presence => { :message => "for course can't be blank" }

  belongs_to :course

  def club
    course.club
  end

  def user
    club.user
  end

  def assign_defaults
    self.title      = Settings.lessons[:default_title]
    self.background = Settings.lessons[:default_background]
  end
end
