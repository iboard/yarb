describe "Jasmine Integration Sample", ->

  beforeEach ->
    loadFixtures "jasmine_integration"

  it "loads the fixture", ->
    expect($("H1")).toHaveText("Jasmine Fixture")

