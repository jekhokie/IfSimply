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
