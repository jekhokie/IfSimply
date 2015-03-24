$(".modal").modal "hide"
$(".modal").removeClass "devise-modal" if $(".modal").hasClass("devise-modal")
window.location.replace "<%= club_registration_notify_path %>"
