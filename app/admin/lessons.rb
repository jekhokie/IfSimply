ActiveAdmin.register Lesson do
  belongs_to :course, :optional => true

  menu priority: 5
  actions :all, :except => [ :new, :edit, :destroy ]
  config.filters = false

  index do
    column :title
    column :background
    column :free
    column :file_attachment_file_name
    column :course do |lesson|
      link_to "Course", admin_course_path(lesson.course)
    end
    default_actions
  end
end
