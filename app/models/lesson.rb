class Lesson < ActiveRecord::Base
  attr_accessible :background, :free, :title, :video

  validates :title,      :presence => { :message => "for lesson can't be blank" }
  validates :background, :presence => { :message => "for lesson can't be blank" }

  belongs_to :course

  def club
    course.club
  end

  def user
    club.user
  end

  def assign_defaults
    self.title      = "Lesson #{(course.lessons.count + 1)} - #{Settings.lessons[:default_title]}"
    self.background = Settings.lessons[:default_background]
    self.free       = Settings.lessons[:default_free]
  end
end
