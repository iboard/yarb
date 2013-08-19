describe 'Jasmine Integration Sample', ->


  beforeEach ->
    loadFixtures 'jasmine_integration'

  it 'loads the fixture', ->
    expect($('H1')).toHaveText('Jasmine Fixture')

  describe 'GlobalActions', ->

    actions = undefined

    beforeEach ->
      $.fn.globalActor = new GlobalActions()
      actions = $(window).globalActor

    it 'installs the hooks from the constructor', ->
      spyOn actions, 'installHooks'
      actions.constructor('installHooks')
      expect(actions.installHooks).toHaveBeenCalled()

    it 'installs a ScrollToTop function for the header', ->
      spyOn(actions, 'scrollPageToTop').andCallThrough()
      $('header .container').click()
      expect(actions.scrollPageToTop).toHaveBeenCalled()

    it 'installs a ScrollToTop function for the footer', ->
      spyOn(actions, 'scrollPageToTop').andCallThrough()
      $('footer .container').click()
      expect(actions.scrollPageToTop).toHaveBeenCalled()

