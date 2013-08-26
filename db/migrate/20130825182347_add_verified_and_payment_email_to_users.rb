class AddVerifiedAndPaymentEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verified,      :boolean, :default => false
    add_column :users, :payment_email, :string
  end
end
