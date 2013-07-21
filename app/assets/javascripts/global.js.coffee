jQuery ->
  # set up in-line editing
  $(".best_in_place").each ->
    # handle response for successful video definition
    if $(this).hasClass("video-related")
      $(this).best_in_place()
        .bind "best_in_place:pre_update", ->
          # strip out the src attribute if it exists
          $(this).find("input").val stripEmbedSource($(this).find("input").val())
        .bind "ajax:success", ->
          # update the video container to point at the newly-specified URL
          $(this).closest(".video-container").find("iframe").attr "src", $(this).html()
    else
      $(this).best_in_place()

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

# handle stripping out the src attribute of embed source for videos
stripEmbedSource = (embedCode) ->
  if embedCode.match(/.*\ssrc=[',"](.*?)[',"][\s]?.*?$/)
    strippedCode = embedCode.replace(/.*\ssrc=[',"](.*?)[',"][\s]?.*?$/, "$1")

    return strippedCode if strippedCode.match(/^http:\/\/.*/)

    strippedCode.replace(/^(\/\/)?(.*)/, "http://$2")
  else
    embedCode
