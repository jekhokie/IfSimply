class CoursesController < ApplicationController
  before_filter :authenticate_user!

  def create
    authorize! :create, Course

    @club = Club.find params[:club_id]
    @course = @club.courses.new
    @course.assign_defaults
    @course.save

    render :edit
  end

  def edit
    @course = Course.find params[:id]

    authorize! :edit, @course

    @club = @course.club
  end
end
