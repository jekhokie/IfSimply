# close the current modal and update the image uploaded
$(".modal").modal "hide"
$(".club-avatar img").attr "src", "<%= @club.logo %>"
