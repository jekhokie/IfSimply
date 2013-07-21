# close the current modal and update the image uploaded
$(".modal").modal "hide"
$(".user-icon img").attr "src", "<%= @user.icon.url(:medium) %>"
