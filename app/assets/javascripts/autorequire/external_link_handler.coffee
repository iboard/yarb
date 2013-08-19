jQuery ->

  $(document).ready ->
    $('a').each (i, element) ->
      new ExternalLinkHandler( $(element) )

class @ExternalLinkHandler

  constructor: (link) ->
    @filterLink(link)

  filterLink: (link) =>
    unless link.attr('target')
      if link.prop('hostname') != window.location.hostname && link.prop('hostname') != 'example.com'
        link.attr('target', '_blank')

