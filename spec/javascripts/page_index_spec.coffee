describe "PageIndex", ->

  beforeEach ->
    loadFixtures "page_index.html"

  it "Creates an index of all H1 and H2 items", ->
    indexer = new PageIndex($("#page-index"))
    expect($("#page-index")[0].innerHTML).toMatch("<li><a class=\"page-index-link\" href=\"#idx-1\">Item 1</a></li>")
    expect($("#page-index")[0].innerHTML).toMatch("<ul><li><a class=\"page-index-link\" href=\"#idx-1-1\">Subitem 1.1</a></li></ul>")
    expect($("#page-index")[0].innerHTML).toMatch("<li><a class=\"page-index-link\" href=\"#idx-2\">Item 2</a></li>")
    expect($("#page-index")[0].innerHTML).toMatch("<ul><li><a class=\"page-index-link\" href=\"#idx-2-1\">Subitem 2.1</a></li></ul>")

