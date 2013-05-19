class CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_course, :only => [ :edit, :update ]

  def create
    authorize! :create, Course

    @club = Club.find params[:club_id]
    @course = @club.courses.new
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

  private

  def get_course
    @course = Course.find params[:id]
  end
end
