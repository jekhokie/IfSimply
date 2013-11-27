$(".club-price-container").html "<%= escape_javascript(render :partial => 'admin/club_price', :locals => { :club => @club }, :formats => [ :html ]) %>"
$(".modal").removeClass "club-price-specify-modal" if $(".modal").hasClass("club-price-specify-modal")
$(".modal").modal "hide"
