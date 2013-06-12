class Lesson < ActiveRecord::Base
  attr_accessible :background, :free, :title, :video

  validates :title,      :presence => { :message => "for lesson can't be blank" }
  validates :background, :presence => { :message => "for lesson can't be blank" }
  validate  :url_exists

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

  private

  def url_exists
    errors.add(:base, "URL is not reachable or malformed - please check your video URL") unless VideoManipulator.validate_url(video)
  end
end
