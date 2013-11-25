class AddCallDetailsToSalesPages < ActiveRecord::Migration
  def change
    add_column :sales_pages, :call_details, :text
  end
end
