ActiveAdmin.register SalesPage do
  belongs_to :club, :optional => true

  menu priority: 9
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :heading do |sales_page|
      link_to sales_page.heading, admin_sales_page_path(sales_page)
    end
    column :sub_heading
    column :call_to_action
    column :benefit1
    column :benefit2
    column :benefit3
  end
end
