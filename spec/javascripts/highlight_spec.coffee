describe "CodeHighlighter", ->

    beforeEach ->
      loadFixtures "highlight.html"

    it "interprets code-blocks", ->
      new CodeHighlighter($("pre"))
      expect($("code")[0].innerHTML).toMatch("<span class=\"class\"><span class=\"keyword\">class</span> <span class=\"title\">MyObject</span>")

