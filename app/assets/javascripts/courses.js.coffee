$(document).ready ->
  $("#courses-list").sortable
    axis: "y"
    dropOnEmpty: false
    handle: ".course-handle"
    cursor: "crosshair"
    items: "div.club-course"
    opacity: 0.4
    scroll: true
    update: ->
      $.ajax
        url: "/courses/sort"
        type: "post"
        data:
          courses: $("#courses-list").sortable("toArray")
          club_id: $("#courses-list").attr("data-club")
        dataType: "script"

# show helper modal for Featured
$("#courses-list .top-three-label i.icon-question-sign").livequery ->
  $(this).click ->
    $(".modal .modal-header").html "Featured Courses"
    $(".modal .modal-body").html   "<div class='featured-modal'><div class='featured-explanation'>Use the move icons to re-order your Courses. 'Featured Courses' are the 3 Courses that will be displayed on your Club page, such as in the image below:</div><img alt='Featured Courses' src='/assets/featured_courses.png'></img></div>"
    $(".modal .modal-footer").html "<a onclick=\"$('.modal').modal('hide')\" class='btn btn-info'>Close</a>"
    $(".modal").modal "show"
