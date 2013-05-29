$(".topic-controls").show()
$(".topic-posts").html "<%= escape_javascript(render :partial => 'posts/list', :locals => { :topic => @topic }) %>"
