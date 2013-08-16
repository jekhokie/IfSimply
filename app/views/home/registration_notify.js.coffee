$(".modal").modal "hide"
$(".modal").removeClass "devise-modal" if $(".modal").hasClass("devise-modal")
$(".learn-more-container").html "<%= escape_javascript(render :template => 'home/registration_notify', :formats => [ :html ]) %>"
