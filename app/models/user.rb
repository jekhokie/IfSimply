class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable, :validatable, :timeoutable

  after_create :create_club

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name,  :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true

  has_many :clubs, :dependent => :destroy

  private

  def create_club
    self.clubs.create
  end
end
