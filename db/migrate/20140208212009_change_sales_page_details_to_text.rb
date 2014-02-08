class ChangeSalesPageDetailsToText < ActiveRecord::Migration
  def up
    change_column :sales_pages, :details, :text, :limit => nil
  end

  def down
    change_column :sales_pages, :details, :string
  end
end
