class CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_club, :only => [ :show_all ]
  before_filter :get_course, :only => [ :edit, :update ]

  def create
    @club = Club.find params[:club_id]
    @course = @club.courses.new

    authorize! :create, @course

    @course.assign_defaults
    @course.save

    render :edit
  end

  def edit
    authorize! :edit, @course

    @club = @course.club
  end

  def update
    authorize! :update, @course

    @course.update_attributes params[:course]

    respond_with_bip @course
  end

  def show_all
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
