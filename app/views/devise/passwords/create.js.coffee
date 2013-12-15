$(".modal").addClass "devise-modal" unless $(".modal").hasClass("devise-modal")
$(".modal .modal-header").remove()
$(".modal .modal-body").html "<%= escape_javascript(render :template => 'devise/passwords/new',
                                                           :formats  => [ :html ] ) %>"
$(".modal .modal-footer").remove()
$(".modal").modal "show"
