$(".verified-status-tag").html "<%= escape_javascript(render :partial => 'shared/verified_status_tag', :formats => [ :html ]) %>"
$(".club-admin-status-text").html "<%= escape_javascript(render :partial => 'admin/club_live_status', :formats => [ :html ]) %>"
$(".club-promote-text").html "<%= escape_javascript(render :partial => 'admin/club_promote', :locals => { :club => @club }, :formats => [ :html ]) %>"
$(".modal").removeClass "paypal-confirm-modal" if $(".modal").hasClass("paypal-confirm-modal")
$(".modal").modal "hide"
