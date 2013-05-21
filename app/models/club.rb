class Club < ActiveRecord::Base
  attr_accessible :name, :description, :price_cents, :logo

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
  has_many   :courses, :dependent => :destroy

  def assign_defaults
    self.name        = Settings.clubs[:default_name]
    self.description = Settings.clubs[:default_description]
    self.price_cents = Settings.clubs[:default_price_cents]
  end
end
