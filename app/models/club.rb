class Club < ActiveRecord::Base
  attr_accessible :name, :description, :price_cents, :logo

  after_initialize :assign_defaults

  monetize :price_cents

  validates :name,        :presence => true
  validates :description, :presence => true
  validates :logo,        :presence => true
  validates :price_cents, :presence => true
  validates :user_id,     :presence => true

  validates_numericality_of :price_cents, :greater_than_or_equal_to => Settings.clubs[:min_price_cents],
                                          :message => "must be at least $#{Settings.clubs[:min_price_cents]/100}"

  belongs_to :user

  private

  def assign_defaults
    self.name        = Settings.clubs[:default_name]
    self.description = Settings.clubs[:default_description]
    self.logo        = Settings.clubs[:default_logo]
    self.price_cents = Settings.clubs[:default_price_cents]
  end
end
