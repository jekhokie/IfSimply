$(".modal .modal-header").html "Change Club Logo"

$(".modal .modal-body").html "<%= escape_javascript(render :partial => 'shared/file_upload_form',
                                                           :locals  => { :model_name     => 'club',
                                                                         :model_instance => @club,
                                                                         :attribute_name => 'logo',
                                                                         :image_size     => '256x256 px',
                                                                         :update_route   => upload_logo_for_club_path(@club) }) -%>"

$(".modal .modal-footer").html "<%= escape_javascript(render :partial => 'shared/file_upload_controls') %>"

$(".modal").modal backdrop: 'static'
