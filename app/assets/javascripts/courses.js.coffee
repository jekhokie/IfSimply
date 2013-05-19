$ ->
  # handle updating the width for scrolling through courses
  width = 0

  $(".courses-listing .course").each ->
    width += $(this).outerWidth(true)

  width += $(".courses-listing .course").outerWidth(true) / 3

  $(".courses-listing").css "width", width + "px"
