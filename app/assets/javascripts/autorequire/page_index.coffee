jQuery ->

  # Install PageIndex if there is a css-element with id 'page-index'
  # Though .each is used here, it makes no sense to have more than 
  # one 'page-index' on the html-page.
  $('#page-index').each ->
    new PageIndex( $(this) )

# Collect H1 and H2 divs
# Create an outer ordered list for H1 and an inner unordered list for H2
# Insert the list to #page-index
# Install an on-click event for links in the list and scroll smoothly to the target.
# An example of a css-definition for #page-index is at
#    https://github.com/iboard/yarb/blob/master/app/assets/stylesheets/autorequire/page_index.scss
# Note: the @-sign for the class exports the class for the jasmine-tests.
class @PageIndex

  constructor: (index) ->
    idx = "<ol>"
    level = 1
    $("h1").each ->
      idx += addH1Link $(this), level
      idx += iterateToNextH1 $(this), level
      level += 1
    idx += "</ol>"
    index.html idx
    installSmoothScroll()

  # Format the line for target <li><a href...</li>
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

  # Sets the css-id for target, thus it is addressable
  setIdOfTarget= (target, level) ->
    target.attr("id", "idx-#{level}")

  # format the li-line with the link to target
  liOfTarget= (target, level) ->
    "<li><a class='page-index-link' href='#idx-#{level}'>#{target.html()}</a></li>"

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
