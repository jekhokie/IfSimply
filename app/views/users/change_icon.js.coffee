$(".modal .modal-header").html "Change Your Icon"

$(".modal .modal-body").html "<%= escape_javascript(render :partial => 'shared/file_upload_form',
                                                           :locals  => { :model_name     => 'user',
                                                                         :model_instance => @user,
                                                                         :attribute_name => 'icon',
                                                                         :image_size     => '256x220 px',
                                                                         :update_route   => upload_icon_for_user_path(@user) }) -%>"

$(".modal .modal-footer").html "<%= escape_javascript(render :partial => 'shared/file_upload_controls') %>"

$(".modal").modal backdrop: 'static'
