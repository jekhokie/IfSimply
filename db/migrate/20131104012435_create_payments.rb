class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :payer_email
      t.string :payee_email
      t.string :pay_key

      t.money :total_amount
      t.money :payee_share
      t.money :house_share

      t.timestamps
    end

    add_index :payments, :payer_email
    add_index :payments, :payee_email
  end
end
