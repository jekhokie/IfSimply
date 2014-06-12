class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, :use => [ :slugged, :history ]

  devise :async, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable, :validatable, :timeoutable

  after_create :create_club

  attr_accessible :name, :description, :email, :icon, :password, :password_confirmation, :remember_me

  has_many :clubs, :dependent => :destroy

  has_many :posts, :conditions => proc { "user_id = #{self.id}" }

  has_many :subscriptions, :class_name => ClubsUsers, :dependent => :destroy

  validates :name,        :presence => true
  validates :email,       :presence => true, :uniqueness => true
  validates :description, :presence => { :message => "for user can't be blank" }, :on => :update

  def memberships
    Club.find subscriptions.map(&:club_id)
  end

  def assign_defaults
    self.description = Settings.users[:default_description]
    self.icon        = Settings.users[:default_icon]
    self.verified    = false
  end

  def verified?
    verified
  end

  private

  def should_generate_new_friendly_id?
    true
  end

  def create_club
    club = self.clubs.new
    club.assign_defaults
    club.save :validate => false
  end
end
