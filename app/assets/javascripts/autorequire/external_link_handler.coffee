#
#  Process Links
#
#  1.) Add 'target=_blank' to external links (links to foreign hosts)
#
jQuery ->

  $(document).ready ->
    $('a').each (i, element) ->
      new ExternalLinkHandler( $(element) )


class @ExternalLinkHandler

  constructor: (link) -> filterLink(link)

  filterLink= (link) ->
    unless link.attr('target') # do nothing if target is present.
      if isLocalUrl(link.prop('hostname'))
        link.attr('target', '_blank')

  isLocalUrl= (hostname) ->
    hostname != window.location.hostname &&
    hostname != 'example.com' #necessary for jasmine
