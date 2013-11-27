$(".modal").addClass "club-price-specify-modal" unless $(".modal").hasClass("club-price-specify-modal")
$(".modal .modal-header").hide()
$(".modal .modal-body").html "<%= escape_javascript(render :template => 'clubs/specify_price', :locals => { :club => @club }, :formats => [ :html ]) %>"
$(".modal .modal-footer").hide()
$(".modal").modal "show"
