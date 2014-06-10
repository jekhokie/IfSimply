ActiveAdmin.register User do
  menu priority: 2
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do |user|
    column :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
  end

  show do
    default_main_content

    panel "Clubs" do
      table_for user.clubs do
        column :name do |club|
          link_to club.name, admin_club_path(club)
        end
        column :description
        column :price_cents
        column :free_content
      end
    end
  end

  collection_action :show_unconfirmed, :title => "Unconfirmed Users", :method => :get do
    @users = User.where(:confirmed_at => nil)
  end

  collection_action :show_unverified, :title => "Unverified Users", :method => :get do
    @users = User.where(:verified => false)
  end
end
