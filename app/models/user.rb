class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable, :validatable, :timeoutable

  after_create :create_club

  attr_accessible :name, :description, :email, :password, :password_confirmation, :remember_me

  has_many :clubs, :dependent => :destroy

  has_many :posts, :conditions => proc { "user_id = #{self.id}" }

  has_many :subscriptions, :class_name => ClubsUsers

  has_attached_file :icon, :styles      => { :medium => "256x256>", :thumb => "100x100>" },
                           :default_url => Settings.users[:default_icon]

  validates :name,        :presence => true, :uniqueness => true
  validates :email,       :presence => true, :uniqueness => true
  validates :description, :presence => { :message => "for user can't be blank" }

  validates_attachment_content_type :icon, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'image/tiff' ]

  def memberships
    Club.find subscriptions.map(&:club_id)
  end

  def assign_defaults
    self.description = Settings.users[:default_description]
  end

  private

  def create_club
    club = self.clubs.new
    club.assign_defaults
    club.save :validate => false
  end
end
