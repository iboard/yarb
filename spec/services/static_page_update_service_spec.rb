# -*- encoding : utf-8 -*-

require "spec_helper"

describe StaticPageUpdateService do

  before :each do
    Page.delete_store!
  end

  it "reads md-files from project-root and creates pages" do
    Dir[File.join(Rails.root,"*.md")].each do |file|
      StaticPageUpdateService.new file
      _fname = File.basename(file,".md").downcase
      _title = _fname.upcase
      _page = Page.find _title.downcase
      expect(_page).to be_a(Page)
      expect(_page.title).to eq(_title)
    end
  end
end
