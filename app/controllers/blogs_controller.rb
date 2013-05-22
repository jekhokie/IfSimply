class BlogsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_blog, :only => [ :edit, :update, :change_image, :upload_image ]

  def create
    @club = Club.find params[:club_id]
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

  def change_image
    authorize! :update, @blog
  end

  def upload_image
    authorize! :update, @blog

    if @blog.update_attributes params[:blog]
      redirect_to edit_blog_path(@blog)
    else
      render :change_image, :formats => [ :js ]
    end
  end

  private

  def get_blog
    @blog = Blog.find params[:id]
  end
end
