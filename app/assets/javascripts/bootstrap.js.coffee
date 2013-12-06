$(document).ready ->
  jQuery ->
    $("a[rel~=popover], .has-popover").popover()
    $(".tooltip").tooltip()
    $("a[rel~=tooltip], .has-tooltip").tooltip()
