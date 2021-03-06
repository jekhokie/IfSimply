class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [ :slugged, :history ]

  attr_accessible :content, :free, :image, :title

  default_scope order('created_at ASC')

  validates :title,   :presence => { :message => "for article can't be blank" }
  validates :content, :presence => { :message => "for article can't be blank" }

  validate  :free_is_valid

  belongs_to :club

  def user
    club.user
  end

  def pro?
    free == true ? false : true
  end

  def assign_defaults
    self.title   = Settings.articles[:default_title]
    self.content = Settings.articles[:default_content]
    self.free    = Settings.articles[:default_free]

    if self.club.articles.empty?
      self.image = Settings.articles[:default_initial_image]
    else
      self.image = Settings.articles[:default_image]
    end
  end

  private

  def should_generate_new_friendly_id?
    true
  end

  def free_is_valid
    unless free.to_s =~ /(true|false)/
      errors.add(:base, "Free for article must be either true or false")
    end
  end
end
