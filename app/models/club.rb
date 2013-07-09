class Club < ActiveRecord::Base
  attr_accessible :name, :description, :price_cents, :logo, :price

  after_create :create_discussion_board, :create_sales_page

  has_attached_file :logo, :styles      => { :medium => "256x256>", :thumb => "100x100>" },
                           :default_url => Settings.clubs[:default_logo]

  monetize :price_cents

  validates :name,        :presence => { :message => "for club can't be blank" }
  validates :description, :presence => { :message => "for club can't be blank" }
  validates :price_cents, :presence => true
  validates :user_id,     :presence => true

  validates_attachment_content_type :logo, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'image/tiff' ]

  validates_numericality_of :price_cents, :greater_than_or_equal_to => Settings.clubs[:min_price_cents],
                                          :message                  => "must be at least $#{Settings.clubs[:min_price_cents]/100}"

  belongs_to :user

  has_many :courses, :dependent => :destroy
  has_many :blogs,   :dependent => :destroy
  has_many :topics,  :through   => :discussion_board

  has_one :discussion_board, :dependent => :destroy
  has_one :sales_page,       :dependent => :destroy

  def assign_defaults
    self.name        = Settings.clubs[:default_name]
    self.description = Settings.clubs[:default_description]
    self.price_cents = Settings.clubs[:default_price_cents]
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
end
