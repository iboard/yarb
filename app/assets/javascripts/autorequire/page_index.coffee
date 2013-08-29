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
    installSmoothScroll()


  # Sets the css-id for target, thus it is addressable
  setIdOfTarget= (target, level) ->
    target.attr("id", "idx-#{level}")

  # format the li-line with the link to target
  liOfTarget= (target, level) ->
    "<li><a class='page-index-link' href='#idx-#{level}'>#{target.html()}</a></li>"

  # Set the id of the target, thus it can be addressed
  # and return <li><a href...</li>
  addH1Link= (target, level) ->
    setIdOfTarget target, level
    liOfTarget target, level

  # Wrap the link for a H2 into <ul>..</ul>
  addH2Link= (target, parent_level, level) ->
    str = "<ul>"
    setIdOfTarget target, "#{parent_level}-#{level}"
    str += liOfTarget target, "#{parent_level}-#{level}"
    str += "</ul>"
    str

  # Do next() until another H1 or end of file occurs
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

  # Smooth Scrolling
  installSmoothScroll= () ->
    $('.page-index-link').each ->
      $(this).click (event) ->
        event.preventDefault()
        scrollSmoothTo $(this).attr('href')

  # actually scroll and highlight
  scrollSmoothTo= (target) ->
    element = $(target)
    y = element.position().top
    $('body').animate( { scrollTop: y-40 }, 250 )
    $('#page-index').animate( { "margin-top": "#{y-100}" }, 250 )
    element.effect( 'highlight', 750 )
