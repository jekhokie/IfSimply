class Lesson < ActiveRecord::Base
  attr_accessible :background, :free, :title, :video, :file_attachment

  belongs_to :course
  has_attached_file :file_attachment, :url         => "/system/:attachment/:attachment_id/:id/:hash/:filename",
                                      :hash_secret => "soighow3th2t8hgo2ih#JT(T#y09yt09#)(TY#)(TY)#(G()GVh03gh)(QY(@)YRT()G#H#()g"

  validates_attachment :file_attachment,
    :content_type => { :content_type => /^(audio\/(mpeg|mp3))|(video\/x-ms-wav)|(application\/(vnd.openxmlformats-officedocument.spreadsheetml.sheet|vnd.openxmlformats-officedocument.spreadsheetml.template|vnd.openxmlformats-officedocument.presentationml.template|vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.slideshow|vnd.openxmlformats-officedocument.presentationml.presentation|vnd.openxmlformats-officedocument.presentationml.slide|vnd.openxmlformats-officedocument.wordprocessingml.document|vnd.openxmlformats-officedocument.wordprocessingml.template|vnd.ms-excel.addin.macroEnabled.12|vnd.ms-excel.sheet.binary.macroEnabled.12|vnd.ms-excel|msword|pdf|octet-stream))|(text\/(plain|rtf|richtext))$/ },
    :size         => { :in => 0..10000.kilobytes },
    :hash_secret  => "somesecret"

  validate  :free_is_valid
  validate  :url_exists
  validates :title,      :presence => { :message => "for lesson can't be blank" }
  validates :background, :presence => { :message => "for lesson can't be blank" }

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
    unless video.blank?
      errors.add(:base, "URL is not reachable or malformed - please check your video URL") unless VideoManipulator.validate_url(video)
    end
  end

  def free_is_valid
    unless free.to_s =~ /(true|false)/
      errors.add(:base, "Free for lesson must be either true or false")
    end
  end
end
