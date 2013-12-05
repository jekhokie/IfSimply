class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :subject, :use => [ :slugged, :history ]

  attr_accessible :description, :subject, :user_id

  validates :subject,     :presence => { :message => "for topic can't be blank" }
  validates :description, :presence => { :message => "for topic can't be blank" }

  belongs_to :discussion_board

  has_many :posts, :dependent => :destroy

  def poster
    begin
      User.try(:find, user_id)
    rescue
      'unknown'
    end
  end

  def last_updated_time
    updated_at
  end

  def club
    discussion_board.club
  end

  private

  def should_generate_new_friendly_id?
    true
  end
end
