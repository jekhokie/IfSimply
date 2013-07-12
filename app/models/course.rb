class Course < ActiveRecord::Base
  attr_accessible :description, :logo, :title

  has_attached_file :logo, :styles      => { :medium => "275x185>" },
                           :default_url => Settings.courses[:default_logo]

  validates :title,       :presence => { :message => "for course can't be blank" }
  validates :description, :presence => { :message => "for course can't be blank" }
  validates :club_id,     :presence => true

  validates_attachment_content_type :logo, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'image/tiff' ]

  belongs_to :club

  has_many :lessons, :dependent => :destroy

  def user
    club.user
  end

  def assign_defaults
    self.title       = Settings.courses[:default_title]
    self.description = Settings.courses[:default_description]
  end
end
