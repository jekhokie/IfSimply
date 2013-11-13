class Blog < ActiveRecord::Base
  attr_accessible :content, :free, :image, :title

  default_scope order('created_at ASC')

  validates :title,   :presence => { :message => "for blog can't be blank" }
  validates :content, :presence => { :message => "for blog can't be blank" }

  validate  :free_is_valid

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
    self.image   = Settings.blogs[:default_image]
  end

  private

  def free_is_valid
    unless free.to_s =~ /(true|false)/
      errors.add(:base, "Free for blog must be either true or false")
    end
  end
end
