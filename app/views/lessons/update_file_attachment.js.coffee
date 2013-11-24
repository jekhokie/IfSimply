$(".lesson-file-attachment-<%= @lesson.id %> .file-attachment-errors").html "<%= flash[:error] %>"
$(".lesson-file-attachment-<%= @lesson.id %> .lesson-filename").html "<%= escape_javascript(render :partial => 'lessons/file_link', :locals => { :material => @lesson.file_attachment }, :formats => [ :html ]) %>"
