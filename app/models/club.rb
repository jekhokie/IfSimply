class Club < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [ :slugged, :history ]

  attr_accessible :name, :sub_heading, :description, :price_cents, :logo, :price, :default_free_content,
                  :courses_heading, :articles_heading, :discussions_heading, :lessons_heading

  after_create :create_discussion_board, :create_sales_page, :create_upsell_page

  monetize :price_cents

  validates :name,                :presence => { :message => "for club can't be blank" }
  validate  :name_length
  validates :sub_heading,         :presence => { :message => "for club can't be blank" }
  validate  :sub_heading_length
  validates :courses_heading,     :presence => { :message => "for club can't be blank" }
  validates :articles_heading,    :presence => { :message => "for club can't be blank" }
  validates :discussions_heading, :presence => { :message => "for club can't be blank" }
  validates :lessons_heading,     :presence => { :message => "for club can't be blank" }
  validates :description,         :presence => { :message => "for club can't be blank" }
  validates :price_cents,         :presence => true
  validates :user_id,             :presence => true

  validate :free_content_is_valid

  validates_numericality_of :price_cents, :greater_than_or_equal_to => Settings.clubs[:min_price_cents],
                                          :message                  => "must be at least $#{Settings.clubs[:min_price_cents]/100}"

  belongs_to :user

  has_many :courses,  :dependent => :destroy, :order => "position"
  has_many :articles, :dependent => :destroy
  has_many :topics,   :through   => :discussion_board

  has_many :subscriptions, :class_name => ClubsUsers

  has_one :discussion_board, :dependent => :destroy
  has_one :sales_page,       :dependent => :destroy
  has_one :upsell_page,      :dependent => :destroy

  has_many :lessons, :through => :courses

  def members
    User.find subscriptions.select{ |subscription| subscription.level == "basic" or subscription.pro_status == "ACTIVE" }.map(&:user_id)
  end

  def assign_defaults
    self.name         = Settings.clubs[:default_name]
    self.sub_heading  = Settings.clubs[:default_sub_heading]
    self.description  = Settings.clubs[:default_description]
    self.free_content = Settings.clubs[:default_free_content]
    self.price_cents  = Settings.clubs[:default_price_cents]
    self.logo         = Settings.clubs[:default_logo]

    # defaults for renaming headings
    self.courses_heading     = Settings.clubs[:default_courses_heading]
    self.articles_heading    = Settings.clubs[:default_articles_heading]
    self.discussions_heading = Settings.clubs[:default_discussions_heading]
    self.lessons_heading     = Settings.clubs[:default_lessons_heading]
  end

  private

  def should_generate_new_friendly_id?
    true
  end

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

  def create_upsell_page
    upsell_page = UpsellPage.new
    upsell_page.club = self
    upsell_page.assign_defaults
    upsell_page.save :validate => false
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

  def free_content_is_valid
    unless free_content.to_s =~ /(true|false)/
      errors.add(:base, "Free content for club must be either true or false")
    end
  end
end
