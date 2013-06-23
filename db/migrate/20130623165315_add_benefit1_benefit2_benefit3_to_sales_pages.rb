class AddBenefit1Benefit2Benefit3ToSalesPages < ActiveRecord::Migration
  def change
    add_column :sales_pages, :benefit1, :string
    add_column :sales_pages, :benefit2, :string
    add_column :sales_pages, :benefit3, :string
  end
end
