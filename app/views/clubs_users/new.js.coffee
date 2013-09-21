$(".inner-container").html "<%= escape_javascript(render :partial => 'clubs_users/club_user', :formats => [ :html ], :locals => { :club         => @club,
                                                                                                                                  :subscription => @subscription }) %>"
