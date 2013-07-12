class Blog < ActiveRecord::Base
  attr_accessible :content, :free, :image, :title

  default_scope order('created_at ASC')

  has_attached_file :image, :styles     => { :medium => "215x185>", :thumb => "128x128" },
                            :default_url => Settings.clubs[:default_logo]

  validates :title,   :presence => { :message => "for blog can't be blank" }
  validates :content, :presence => { :message => "for blog can't be blank" }

  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'image/tiff' ]

  belongs_to :club

  def user
    club.user
  end

  def pro?
    free == true ? false : true
  end

  def assign_defaults
    self.title   = Settings.blogs[:default_title]
    self.content = Settings.blogs[:default_content]
    self.free    = Settings.blogs[:default_free]
  end
end
