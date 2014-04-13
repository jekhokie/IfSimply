$(document).ready ->
  $(".upsell-page-link").hide() if $(".upsell-page-link").length > 0 and $(".upsell-page-link").hasClass("non-free-hide")

  $('.paid-only-toggle').livequery ->
    $(this).bind "ajax:success", ->
      if $(this).find("i").hasClass("icon-check")
        $(".upsell-page-link").show "fast"
      else
        $(".upsell-page-link").hide "fast"
