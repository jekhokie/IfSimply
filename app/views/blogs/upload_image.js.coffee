# close the current modal and update the image uploaded
$(".modal").modal "hide"
$(".blog-image img").attr "src", "<%= @blog.image %>"
