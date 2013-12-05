class DiscussionBoard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [ :slugged, :history ]

  attr_accessible :description, :name

  validates :name,        :presence => { :message => "for discussion board can't be blank" }
  validates :description, :presence => { :message => "for discussion board can't be blank" }

  belongs_to :club

  has_many :topics, :dependent => :destroy
  has_many :posts,  :through   => :topics

  def user
    club.user
  end

  def assign_defaults
    self.name        = Settings.discussion_boards[:default_name]
    self.description = Settings.discussion_boards[:default_description]
  end

  private

  def should_generate_new_friendly_id?
    true
  end
end
