jQuery ->
  $('.best_in_place').best_in_place().bind "ajax:success", ->
    $(this).closest(".video-container").find("iframe").attr "src", $(this).html() if $(this).hasClass("video-related")
