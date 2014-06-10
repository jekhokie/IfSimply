ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Total Users", :id => "admin_current_users" do
          link_to User.all.count, admin_users_path
        end
      end

      column do
        panel "Unconfirmed Users", :id => "admin_unconfirmed_users" do
          link_to User.where(:confirmed_at => nil).count, show_unconfirmed_admin_users_path
        end
      end

      column do
        panel "Unverified Users", :id => "admin_unverified_users" do
          link_to User.where(:verified => false).count, show_unverified_admin_users_path
        end
      end
    end

    panel "IfSimply Users" do
      table_for User.all do
        column :name
        column :email do |user|
          link_to user.email, admin_user_path(user)
        end
        column :confirmed do |user|
          !user.confirmed_at.nil?
        end
        column :verified
        column :club_name do |user|
          user.clubs.first.name
        end
        column :club_price do |user|
          "$#{user.clubs.first.price} / mo"
        end
        column :basic_sub do |user|
          ClubsUsers.where(:club_id => user.clubs.first.id, :level => "basic").count
        end
        column :pro_sub do |user|
          ClubsUsers.where(:club_id => user.clubs.first.id, :level => "pro").count
        end
        column :courses do |user|
          user.clubs.first.courses.count
        end
        column :articles do |user|
          user.clubs.first.articles.count
        end
        column :discussion_topics do |user|
          user.clubs.first.discussion_board.topics.count
        end
      end
    end
  end
end
