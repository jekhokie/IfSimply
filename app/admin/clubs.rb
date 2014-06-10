ActiveAdmin.register Club do
  belongs_to :user, :optional => true

  menu priority: 3
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :name do |club|
      link_to club.name, admin_club_path(club)
    end
    column :description
    column :sub_heading
    column :created_at
    column :updated_at
    column :free_content
    column :sales_page do |club|
      link_to "Sales Page", admin_sales_page_path(club.sales_page)
    end
  end

  show do
    default_main_content

    panel "Sales Page" do
      link_to "Sales Page", admin_sales_page_path(club.sales_page)
    end

    panel "Upsell Page" do
      link_to "Upsell Page", admin_upsell_page_path(club.upsell_page)
    end

    panel "Discussion Board" do
      link_to "Discussion Board", admin_discussion_board_path(club.discussion_board)
    end

    panel "Courses" do
      table_for club.courses do
        column :title do |course|
          link_to course.title, admin_course_path(course)
        end
        column :description
        column :lessons do |course|
          course.lessons.count
        end
      end
    end

    panel "Articles" do
      table_for club.articles do
        column :title do |article|
          link_to article.title, admin_article_path(article)
        end
        column :free
      end
    end
  end
end
