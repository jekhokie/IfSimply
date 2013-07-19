class BlogsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club, :only => [ :create, :show_all ]
  before_filter :get_blog, :only => [ :show, :edit, :update, :change_image, :upload_image ]

  def show
    redirect_to club_sales_page_path(@blog.club) unless user_signed_in? and can?(:read, @blog)
  end

  def create
    @blog = @club.blogs.new

    authorize! :create, @blog

    @blog.assign_defaults
    @blog.save

    render :edit
  end

  def edit
    authorize! :edit, @blog

    @club = @blog.club
  end

  def update
    authorize! :update, @blog

    @blog.update_attributes params[:blog]

    respond_with_bip @blog
  end

  def show_all
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)

    @blogs = @club.blogs
  end

  def change_image
    authorize! :update, @blog
  end

  def upload_image
    authorize! :update, @blog

    # if no blog image was specified
    if params[:blog].blank?
      render :change_image, :formats => [ :js ]
    elsif @blog.update_attributes params[:blog]
      render
    else
      render :change_image, :formats => [ :js ]
    end
  end

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_blog
    @blog = Blog.find params[:id]
  end
end
