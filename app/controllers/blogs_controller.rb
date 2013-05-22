class BlogsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @club = Club.find params[:club_id]
    @blog = @club.blogs.new

    authorize! :create, @blog

    @blog.assign_defaults
    @blog.save

    render :edit
  end

  def edit
    @blog = Blog.find params[:id]

    authorize! :edit, @blog

    @club = @blog.club
  end
end
