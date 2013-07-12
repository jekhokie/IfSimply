$(".modal .modal-header").html "Change Blog Image"

$(".modal .modal-body").html "<%= escape_javascript(render :partial => 'shared/file_upload_form',
                                                           :locals  => { :model_name     => 'blog',
                                                                         :model_instance => @blog,
                                                                         :attribute_name => 'image',
                                                                         :image_size     => '215x285 px',
                                                                         :update_route   => upload_image_for_blog_path(@blog) }) -%>"

$(".modal .modal-footer").html "<%= escape_javascript(render :partial => 'shared/file_upload_controls') %>"

$(".modal").modal backdrop: 'static'
