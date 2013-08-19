describe 'ExternalLinkHandler', ->

    beforeEach ->
      loadFixtures 'external_links.html'
      new ExternalLinkHandler( $('#external-link') )
      new ExternalLinkHandler( $('#local-link') )
      new ExternalLinkHandler( $('#same-host') )
      new ExternalLinkHandler( $('#to-the-river') )

    it 'link to root_path should be local', ->
      expect($('#external-link').attr('target')).toEqual('_blank')
      expect($('#local-link').attr('target')).toBe( undefined )
      expect($('#same-host').attr('target')).toBe( undefined )
      expect($('#to-the-river').attr('target')).toEqual('to-the-river')

