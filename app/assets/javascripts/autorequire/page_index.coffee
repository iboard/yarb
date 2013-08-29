jQuery ->

  $('#page-index').each ->
    new PageIndex( $(this) )


class @PageIndex

  constructor: (index) ->
    idx = "<ol>"
    l1 = 1
    $("h1").each ->
      idx += addH1Link $(this), l1
      idx += iterateToNextH1 $(this), l1
      l1 += 1
    idx += "</ol>"
    index.html idx


  setIdOfTarget= (target, level) ->
    target.attr("id", "idx-#{level}")

  liOfTarget= (target, level) ->
    "<li><a href='#idx-#{level}'>#{target.html()}</a></li>"

  addH1Link= (target, level) ->
    setIdOfTarget target, level
    liOfTarget target, level

  addH2Link= (target, parent_level, level) ->
    str = "<ul>"
    setIdOfTarget target, "#{parent_level}-#{level}"
    str += liOfTarget target, "#{parent_level}-#{level}"
    str += "</ul>"
    str

  iterateToNextH1= (from, level) ->
    str = ""
    _next = from.next()
    sublevel = 1
    while _next != undefined && _next.length > 0
      if _next.is("h1") 
        break
      if _next.is("h2")
        str += addH2Link _next, level, sublevel
        sublevel += 1
      _next = _next.next()
    str

