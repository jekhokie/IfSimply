class AddDetailsToSalesPage < ActiveRecord::Migration
  def change
    add_column :sales_pages, :details, :string
  end
end
