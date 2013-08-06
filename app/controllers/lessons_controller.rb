class LessonsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_course

  def create
    @lesson = @course.lessons.new

    authorize! :create, @lesson

    @lesson.assign_defaults
    @lesson.save

    redirect_to course_editor_path(@course)
  end

  def update
    @lesson = @course.lessons.find params[:id]

    authorize! :update, @lesson

    @lesson.update_attributes params[:lesson]

    respond_with_bip @lesson
  end

  private

  def get_course
    @course = Course.find params[:course_id]
  end
end
