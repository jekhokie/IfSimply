$(".header-container").html "<%= escape_javascript(render :partial => 'shared/header_container', :formats => [ :html ]) %>"
$(".inner-container").html "<%= escape_javascript(render :partial => 'clubs_users/club_user', :formats => [ :html ], :locals => { :club         => @club,
                                                                                                                                  :subscription => @subscription }) %>"
$(".modal").modal "hide"
