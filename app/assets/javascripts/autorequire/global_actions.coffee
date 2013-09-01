jQuery ->

  # Initialize the globalAction class
  $(document).ready -> new GlobalActions()

  # 1. Click on Header or Footer scrolls to top of page.

class @GlobalActions

  constructor: ->
    $.fn.globalActor = this
    @installHooks()

  #
  # install jQuery-callbacks for various selectors and call
  # GlobalAction-Function when it's triggerd.
  #
  installHooks: ->
    $('header .navbar .navbar-inner .container').on 'click', event, ->
      $(window).globalActor.scrollPageToTop()

    $('footer .container').on 'click', event, ->
      $(window).globalActor.scrollPageToTop()

  #
  # Functions called by hooks
  #
  scrollPageToTop: ->
    $('body').animate( { scrollTop: 0 }, 250 )


