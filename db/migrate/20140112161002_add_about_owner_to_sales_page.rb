class AddAboutOwnerToSalesPage < ActiveRecord::Migration
  def change
    add_column :sales_pages, :about_owner, :text, :limit => nil
  end
end
