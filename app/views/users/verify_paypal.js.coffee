$(".account-status-paypal").html "<%= escape_javascript(render :partial => 'devise/registrations/verified_status', :formats => [ :html ]) %>"
$(".account-status-linked").html "<%= escape_javascript(render :partial => 'users/club_live_status', :formats => [ :html ]) %>"
$(".verified-status-tag").html "<%= escape_javascript(render :partial => 'shared/verified_status_tag', :formats => [ :html ]) %>"
$(".modal").removeClass "paypal-confirm-modal" if $(".modal").hasClass("paypal-confirm-modal")
$(".modal").modal "hide"
