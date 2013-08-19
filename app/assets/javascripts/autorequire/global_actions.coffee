jQuery ->

  $(document).ready -> new GlobalActions()


class @GlobalActions

  constructor: ->
    $.fn.globalActor = this
    @installHooks()

  installHooks: ->
    $('header .navbar .navbar-inner .container').on 'click', event, ->
      $(window).globalActor.scrollPageToTop()

    $('footer .container').on 'click', event, ->
      $(window).globalActor.scrollPageToTop()

  scrollPageToTop: =>
    $('body').animate( { scrollTop: 0 }, 250 )
