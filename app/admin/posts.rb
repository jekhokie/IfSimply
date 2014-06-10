ActiveAdmin.register Post do
  belongs_to :topic, :optional => true

  menu priority: 8
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :content do |post|
      link_to post.content, admin_post_path(post)
    end
    column :created_at
  end
end
