$(".modal").modal "hide"
$(".flash-box").html "<%= escape_javascript(render :partial => 'shared/flash_message', :locals => { :key => :success, :value => 'Please check your email for further instructions' }) %>"
