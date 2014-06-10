ActiveAdmin.register Course do
  belongs_to :club, :optional => true

  menu priority: 4
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :title do |course|
      link_to course.title, admin_course_path(course)
    end
    column :description
    column :club do |course|
      link_to "Club", admin_club_path(course.club)
    end
  end

  show do
    default_main_content

    panel "Lessons" do
      table_for course.lessons do
        column :title do |lesson|
          link_to lesson.title, admin_lesson_path(lesson)
        end
        column :background
        column :free
        column :video
      end
    end
  end
end
