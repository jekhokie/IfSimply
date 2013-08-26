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

# show helper modal for verification status information
$(".verified-nav-status").livequery ->
  $(this).click ->
    $(".modal .modal-header").html "Verified Account"
    $(".modal .modal-header").show()
    $(".modal .modal-body").html   "Verified means that your account has been linked to a valid, verified PayPal account, and members are able to subscribe to/you are able to receive funds from Pro subscriptions. To check or update your verification status, click the 'Account' link in the navigation bar."
    $(".modal .modal-footer").html "<a onclick=\"$('.modal').modal('hide')\" class='btn btn-primary'>Close</a>"
    $(".modal .modal-footer").show()
    $(".modal").modal "show"

jQuery ->
  # set up in-line editing
  $(".best_in_place").each ->
    $(this).best_in_place()

# mercury update hooks
jQuery(window).on "mercury:ready", ->
  # Mercury.on "action", (event, actionType) ->
  #   # save button clicked
  #   if actionType.action == "save"

  # page saved successfully
  Mercury.on "saved", (event, element) ->
    alert "Page saved successfully!"

  Mercury.on "mode", (event, eventType) ->
    # preview button clicked
    if eventType.mode == "preview"
      $(".hide-preview").toggleClass "hidden-element"

  Mercury.on "region:blurred", (event, obj) ->
    # handle updating video URLs
    if obj.region.element.parent().hasClass "video-related"
      unless obj.region.element.val() == window.videoSource
        videoSource = stripEmbedSource(obj.region.element.val())
        window.videoSource = videoSource
        obj.region.element.val videoSource
        obj.region.element.closest(".video-container").find("iframe").attr "src", videoSource

# handle stripping out the src attribute of embed source for videos
stripEmbedSource = (embedCode) ->
  if embedCode.match(/.*\ssrc=[',"](.*?)[',"][\s]?.*?$/)
    strippedCode = embedCode.replace(/.*\ssrc=[',"](.*?)[',"][\s]?.*?$/, "$1")

    return strippedCode if strippedCode.match(/^http:\/\/.*/)

    strippedCode.replace(/^(\/\/)?(.*)/, "http://$2")
  else
    embedCode
