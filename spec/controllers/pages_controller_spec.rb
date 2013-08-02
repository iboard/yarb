require_relative '../spec_helper'

describe PagesController do
  
  render_views

  let(:page1) { Page.create( title: 'Page One', body: 'Body of page number one') }
  let(:page2) { Page.create( title: 'Page Two', body: 'Body of page number two') }

  before :each do
    page1; page2 #create the pages
    visit pages_path
  end

  it 'should list available pages' do
    within '#container.container' do
      page.should have_css('h1', :text => 'Available Pages')
      page.should have_css('li#page-page-one', :text => 'Page One')
      page.should have_css('li#page-page-two', :text => 'Page Two')
    end
  end

end
