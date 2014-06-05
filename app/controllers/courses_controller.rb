class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show, :show_all ]
  before_filter :get_club,   :only => [ :create, :show_all, :sort ]
  before_filter :get_course, :only => [ :show, :edit, :update ]

  def show
    redirect_to club_sales_page_path(@course.club) and return unless (user_signed_in? and can?(:read, @course))

    if request.path != course_path(@course)
      redirect_to course_path(@course), status: :moved_permanently and return
    end
  end

  def edit
    authorize! :update, @course
    @club = @course.club

    if request.path != course_path(@course)
      render course_editor_path(@course), :text => "", :status => :moved_permanently, :layout => "mercury" and return
    end
  end

  def create
    @course = @club.courses.new

    authorize! :create, @course

    @course.assign_defaults

    if @course.save and @club.courses.count == 1  # first Course - build initial Lesson
      @lesson = @course.lessons.new
      @lesson.assign_defaults
      @lesson.save
    end

    redirect_to course_editor_path(@course)
  end

  def update
    authorize! :update, @course

    course_hash                  = params[:content]
    @course.title                = course_hash[:course_title][:value]
    @course.description          = course_hash[:course_description][:value]
    @course.logo                 = course_hash[:course_logo][:attributes][:src]
    @course.club.lessons_heading = course_hash[:club_lessons_heading][:value]

    # update the corresponding lessons for the course
    lesson_list = []
    course_hash.each do |lesson_id, lesson_hash|
      if lesson_id =~ /lesson_.*/
        lesson = lesson_list.select{ |lesson| lesson.id.to_s == lesson_id.split("_")[1] }.first
        lesson = @course.lessons.find lesson_id.split("_")[1] if lesson.blank?

        unless lesson.blank?
          attribute = lesson_id.split("_")[2]
          lesson.send "#{attribute}=", lesson_hash[:value]

          lesson_list.delete lesson if lesson_list.include?(lesson)
          lesson_list << lesson
        end
      end
    end

    # handle errors for the course and each lesson
    error_resources = []
    error_resources << @course unless @course.save
    lesson_list.each do |lesson|
      error_resources << lesson unless lesson.save
    end
    error_resources << @course.club unless @course.club.save

    if error_resources.blank?
      render :text => ""
    else
      respond_error_to_mercury error_resources
    end
  end

  def show_all
    redirect_to club_sales_page_path(@club) unless user_signed_in? and can?(:read, @club)

    @courses = @club.courses
  end

  def sort
    authorize! :update, @club

    courses = @club.courses

    unless (course_list = params["courses"]).nil?
      course_list.map!{ |course| course.sub("course_", "") }

      courses.each do |course|
        course.position = course_list.index(course.id.to_s) + 1
        course.save
      end
    end

    render :nothing => true
  end

  def destroy
    course = Course.find params[:id]
    @club  = course.club

    authorize! :destroy, course

    flash[:error] = "An error occurred destroying the Course" unless course.destroy

    redirect_to show_all_club_courses_path(@club)

    flash.discard
  end

  private

  def get_club
    @club = Club.find params[:club_id]
  end

  def get_course
    @course = Course.find params[:id]
  end
end
