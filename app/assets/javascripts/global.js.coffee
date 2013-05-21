jQuery ->
  $(".best_in_place").best_in_place().bind "ajax:success", ->
    $(this).closest(".video-container").find("iframe").attr "src", $(this).html() if $(this).hasClass("video-related")

  # handle updating the new file for upload display
  $("label.file-upload-label input").livequery ->
    $(this).on "change", ->
      fileName = $(this).val().replace(/^.*[\\\/]/, '')
      fileText = "<span class='file-preview-text'>New File: </span>" + fileName
      $(this).closest(".new-file-select").find(".selected-file-preview").html fileText
