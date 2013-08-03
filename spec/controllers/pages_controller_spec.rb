require_relative '../spec_helper'

describe PagesController do
  
  render_views

  let(:page1) { Page.create( title: 'Page One', body: 'Body of page number one') }
  let(:page2) { Page.create( title: 'Page Two', body: 'Body of page number two') }

  before :each do
    visit switch_locale_path(:en)
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

  it 'should list all md-files from project-root as links' do
    within '#container.container' do
      Dir[File.join(Rails.root,'*.md')].each do |file|
        _fname = File.basename(file,'.md').downcase
        _title = _fname.upcase
        within "li#page-#{_fname}" do
          page.should have_link( _title )
        end
      end
    end
  end

  it 'should show md-pages' do
    within 'li#page-store' do
      click_link 'STORE'
    end
    within 'article' do
      page.should have_text( 'How the Store-Module works' )
    end
  end

  it 'renders an error if page not found' do
    visit page_path('not_existing_page_321')
    within( '.alert-error' ) do
      page.should have_content('Page not_existing_page_321 doesn\'t exist')
    end
    expect(response.status).to eq(404)
  end

end
