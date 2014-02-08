class LessonsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_course, :except => [ :destroy ]

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

  def update_file_attachment
    @lesson = @course.lessons.find params[:lesson_id]

    authorize! :update, @lesson

    unless @lesson.update_attributes params[:lesson]
      flash[:error] = "File attachment '#{@lesson.file_attachment.original_filename}' content type unsupported."
      @lesson.reload
    end

    flash.discard
  end

  def destroy
    lesson  = Lesson.find params[:id]
    @course = lesson.course

    authorize! :destroy, lesson

    flash[:error] = "An error occurred destroying the Lesson" unless lesson.destroy

    redirect_to course_editor_path(@course)

    flash.discard
  end

  private

  def get_course
    @course = Course.find params[:course_id]
  end
end
