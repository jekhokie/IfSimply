class CreateSalesPages < ActiveRecord::Migration
  def change
    create_table :sales_pages do |t|
      t.string :heading
      t.string :sub_heading
      t.string :call_to_action

      t.references :club

      t.timestamps
    end
  end
end
