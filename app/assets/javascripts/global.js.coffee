jQuery ->
  $(".best_in_place").best_in_place().bind "ajax:success", ->
    $(this).closest(".video-container").find("iframe").attr "src", $(this).html() if $(this).hasClass("video-related")

  # handle updating the new file for upload display
  $("label.file-upload-label input").livequery ->
    $(this).on "change", ->
      fileName = $(this).val().replace(/^.*[\\\/]/, '')
      fileText = "<span class='file-preview-text'>New File: </span>" + fileName
      $(this).closest(".new-file-select").find(".selected-file-preview").html fileText

# handle 401 responses (unauthorized) when AJAX requests
$.ajaxSetup statusCode:
  401: ->
    location.href = "/users/sign_in"

# show helper modal for video embed source
$(".video-embed-label i.icon-question-sign").livequery ->
  $(this).click ->
    $(".modal .modal-header").html "Video Embed Code Example - YouTube"
    $(".modal .modal-body").html   "<img alt='video-embed-img' src='/assets/embed_helper.png'>"
    $(".modal .modal-footer").html "<a onclick=\"$('.modal').modal('hide')\" class='btn btn-info'>Close</a>"
    $(".modal").modal "show"
