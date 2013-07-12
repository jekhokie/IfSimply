# close the current modal and update the image uploaded
$(".modal").modal "hide"
$(".course-logo img").attr "src", "<%= @course.logo.url(:medium) %>"
