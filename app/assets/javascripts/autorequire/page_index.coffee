jQuery ->

  $('#page-index').each ->
    new PageIndex( $(this) )


class @PageIndex

  constructor: (index) ->
    idx = "<ol>"
    l1 = 1
    $("h1").each ->
      $(this).attr("id", "idx-#{l1}")
      idx += "<li><a href='#idx-#{l1}'>#{$(this).html()}</a></li>"
      _next = $(this).next()
      l2 = 1
      while _next != undefined && _next.length > 0
        if _next.is("h1") 
          break
        if _next.is("h2")
          idx += "<ul>"
          _next.attr("id", "idx-#{l1}-#{l2}")
          idx += "<li><a href='#idx-#{l1}-#{l2}'>#{_next.html()}</a></li>"
          l2 += 1
          idx += "</ul>"
        _next = _next.next()
      l1 += 1
    idx += "</ol>"
    index.html idx
