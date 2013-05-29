class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_topic, :only => [ :new, :create ]

  def new
    authorize! :update, @topic

    @post = @topic.posts.new :user_id => current_user.id
  end

  def create
    authorize! :update, @topic

    @post         = @topic.posts.new params[:post]
    @post.user_id = current_user.id

    if @post.save
      flash[:notice] = "Post created successfully"

      @posts = @topic.posts

      render
    else
      render :new, :locals => { :topic => @topic, :post => @post }
    end

    flash.discard
  end

  private

  def get_topic
    @topic = Topic.find params[:topic_id]
  end
end
