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
end
