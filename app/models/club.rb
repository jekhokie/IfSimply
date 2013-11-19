class Club < ActiveRecord::Base
  attr_accessible :name, :sub_heading, :description, :price_cents, :logo, :price

  after_create :create_discussion_board, :create_sales_page

  monetize :price_cents

  validates :name,        :presence => { :message => "for club can't be blank" }
  validate  :name_length
  validates :sub_heading, :presence => { :message => "for club can't be blank" }
  validate  :sub_heading_length
  validates :description, :presence => { :message => "for club can't be blank" }
  validates :price_cents, :presence => true
  validates :user_id,     :presence => true

  validates_numericality_of :price_cents, :greater_than_or_equal_to => Settings.clubs[:min_price_cents],
                                          :message                  => "must be at least $#{Settings.clubs[:min_price_cents]/100}"

  belongs_to :user

  has_many :courses,  :dependent => :destroy, :order => "position"
  has_many :articles, :dependent => :destroy
  has_many :topics,   :through   => :discussion_board

  has_many :subscriptions, :class_name => ClubsUsers

  has_one :discussion_board, :dependent => :destroy
  has_one :sales_page,       :dependent => :destroy

  has_many :lessons, :through => :courses

  def members
    User.find subscriptions.select{ |subscription| subscription.level == "basic" or subscription.pro_status == "ACTIVE" }.map(&:user_id)
  end

  def assign_defaults
    self.name        = Settings.clubs[:default_name]
    self.sub_heading = Settings.clubs[:default_sub_heading]
    self.description = Settings.clubs[:default_description]
    self.price_cents = Settings.clubs[:default_price_cents]
    self.logo        = Settings.clubs[:default_logo]
  end

  private

  def create_discussion_board
    discussion_board = DiscussionBoard.new
    discussion_board.club = self
    discussion_board.assign_defaults
    discussion_board.save :validate => false
  end

  def create_sales_page
    sales_page = SalesPage.new
    sales_page.club = self
    sales_page.assign_defaults
    sales_page.save :validate => false
  end

  def name_length
    unless name.blank?
      errors.add(:base, "Name length too long - must be #{Settings.clubs[:name_max_length]} characters or less") unless self.name.length <= Settings.clubs[:name_max_length]
    end
  end

  def sub_heading_length
    unless sub_heading.blank?
      errors.add(:base, "Sub heading length too long - must be #{Settings.clubs[:sub_heading_max_length]} characters or less") unless self.sub_heading.length <= Settings.clubs[:sub_heading_max_length]
    end
  end
end
