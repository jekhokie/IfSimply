class BlogsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club, :only => [ :create, :show_all ]
  before_filter :get_blog, :only => [ :show, :edit, :update ]

  def show
    redirect_to club_sales_page_path(@blog.club) unless user_signed_in? and can?(:read, @blog)
  end

  def create
    @blog = @club.blogs.new

    authorize! :create, @blog

    @blog.assign_defaults
    @blog.save

    redirect_to blog_editor_path(@blog)
  end

  def edit
    authorize! :edit, @blog
    @club = @blog.club

    render :text => '', :layout => "mercury"
  end

  def update
    authorize! :update, @blog

    if params[:blog] and params[:blog][:free]
      @blog.free = params[:blog][:free]
    else
      blog_hash     = params[:content]
      @blog.title   = blog_hash[:blog_title][:value]
      @blog.content = blog_hash[:blog_content][:value]
      @blog.image   = blog_hash[:blog_image][:attributes][:src]
    end

    if @blog.save
      render :text => ""
    else
      respond_error_to_mercury [ @blog ]
    end
  end

  def show_all
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)

    @blogs = @club.blogs
  end

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_blog
    @blog = Blog.find params[:id]
  end
end
