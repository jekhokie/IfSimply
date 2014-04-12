$(".topic-posts").append "<%= escape_javascript(render :template => 'posts/new', :formats => [ :html ],
                                                                                 :locals => { :topic => @topic,
                                                                                              :post  => @post }) %>"

$(".topic-controls").hide()
$(".first-post-header").hide() if $(".first-post-header").length > 0
window.scrollTo 0, ($(".new-post").position().top)
