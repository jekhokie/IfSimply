ActiveAdmin.register Topic do
  belongs_to :club, :optional => true

  menu priority: 7
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :subject do |topic|
      link_to topic.subject, admin_topic_path(topic)
    end
    column :description
  end

  show do
    default_main_content

    panel "Posts" do
      table_for topic.posts do
        column :content do |post|
          link_to post.content, admin_post_path(post)
        end
        column :created_at
      end
    end
  end
end
