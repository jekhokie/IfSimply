class AddVideoToSalesPages < ActiveRecord::Migration
  def change
    add_column :sales_pages, :video, :string
  end
end
