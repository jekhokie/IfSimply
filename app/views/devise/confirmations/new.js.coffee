$(".modal").addClass "devise-modal" unless $(".modal").hasClass("devise-modal")
$(".modal .modal-header").remove()
$(".modal .modal-body").html "<%= escape_javascript(render :template => 'devise/confirmations/new',
                                                           :formats  => [ :html ],
                                                           :locals   => { :resource => resource }) %>"
$(".modal .modal-footer").remove()
$(".modal").modal "show"
