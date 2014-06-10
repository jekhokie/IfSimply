ActiveAdmin.register UpsellPage do
  belongs_to :club, :optional => true

  menu priority: 10
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :heading do |upsell_page|
      link_to upsell_page.heading, admin_upsell_page_path(upsell_page)
    end
    column :sub_heading
  end
end
