class LessonsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @course = Course.find params[:course_id]
    @lesson = @course.lessons.new

    authorize! :create, @lesson

    @lesson.assign_defaults
    @lesson.save

    redirect_to edit_course_path(@course)
  end
end
