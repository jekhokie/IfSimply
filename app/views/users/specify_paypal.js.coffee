$(".modal").addClass "paypal-confirm-modal" unless $(".modal").hasClass("paypal-confirm-modal")
$(".modal .modal-header").remove()
$(".modal .modal-body").html "<%= escape_javascript(render :template => 'users/specify_paypal', :formats  => [ :html ]) %>"
$(".modal .modal-footer").remove()
$(".modal").modal "show"
