describe "ExternalLinkHandler", ->

    beforeEach ->
      loadFixtures "external_links.html"
      new ExternalLinkHandler( $("#external-link") )
      new ExternalLinkHandler( $("#local-link") )
      new ExternalLinkHandler( $("#same-host") )
      new ExternalLinkHandler( $("#to-the-river") )

    it "links to localhost should not have target-param", ->
      expect($("#local-link").attr("target")).toBe( undefined )
      expect($("#same-host").attr("target")).toBe( undefined )

    it "links to external pages should have a target=_blank param", ->
      expect($("#external-link").attr("target")).toEqual("_blank")
      expect($("#to-the-river").attr("target")).toEqual("to-the-river")

