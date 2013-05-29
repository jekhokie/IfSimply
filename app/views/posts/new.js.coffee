$(".topic-posts").append "<%= escape_javascript(render :template => 'posts/new', :formats => [ :html ],
                                                                                 :locals => { :topic => @topic,
                                                                                              :post  => @post }) %>"

$(".topic-controls").hide()
window.scrollTo 0, document.body.scrollHeight
