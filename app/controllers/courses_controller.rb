class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club,   :only => [ :create, :show_all ]
  before_filter :get_course, :only => [ :show, :edit, :update ]

  def show
    redirect_to club_sales_page_path(@course.club) unless user_signed_in? and can?(:read, @course)
  end

  def create
    @course = @club.courses.new

    authorize! :create, @course

    @course.assign_defaults
    @course.save

    redirect_to course_editor_path(@course)
  end

  def edit
    authorize! :update, @course
    @club = @course.club

    render :text => '', :layout => "mercury"
  end

  def update
    authorize! :update, @course

    course_hash         = params[:content]
    @course.title       = course_hash[:course_title][:value]
    @course.description = course_hash[:course_description][:value]
    @course.logo        = course_hash[:course_logo][:attributes][:src]

    if @course.save
      render :text => ""
    else
      respond_error_to_mercury [ @course ]
    end
  end

  def show_all
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)

    @courses = @club.courses
  end

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_course
    @course = Course.find params[:id]
  end
end
