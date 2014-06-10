ActiveAdmin.register Article do
  belongs_to :club, :optional => true

  menu priority: 6
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :title do |article|
      link_to article.title, admin_article_path(article)
    end
    column :free
  end
end
