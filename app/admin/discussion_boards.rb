ActiveAdmin.register DiscussionBoard do
  belongs_to :club, :optional => true

  menu priority: 6
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :name do |discussion_board|
      link_to discussion_board.name, admin_discussion_board_path(discussion_board)
    end
    column :description
  end

  show do
    default_main_content

    panel "Topics" do
      table_for discussion_board.topics do
        column :subject do |topic|
          link_to topic.subject, admin_topic_path(topic)
        end
        column :description
        column :posts do |topic|
          topic.posts.count
        end
      end
    end
  end
end
