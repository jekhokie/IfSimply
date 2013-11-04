class Payment < ActiveRecord::Base
  attr_accessible :payer_email, :payee_email, :pay_key, :total_amount, :payee_share, :house_share

  monetize :total_amount_cents
  monetize :payee_share_cents
  monetize :house_share_cents

  validates :payer_email,        :presence => true
  validates :payee_email,        :presence => true
  validates :pay_key,            :presence => true
  validates :total_amount_cents, :presence => true
  validates :payee_share,        :presence => true
  validates :house_share,        :presence => true
end
