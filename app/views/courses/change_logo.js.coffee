$(".modal .modal-header").html "Change Course Logo"

$(".modal .modal-body").html "<%= escape_javascript(render :partial => 'shared/file_upload_form',
                                                           :locals  => { :model_name     => 'course',
                                                                         :model_instance => @course,
                                                                         :attribute_name => 'logo',
                                                                         :image_size     => '275x185 px',
                                                                         :update_route   => upload_logo_for_course_path(@course) }) -%>"

$(".modal .modal-footer").html "<%= escape_javascript(render :partial => 'shared/file_upload_controls') %>"

$(".modal").modal backdrop: 'static'
