require_relative '../spec_helper'

describe LandingsController do

  render_views

  before :each do
    visit root_path
  end

  it 'displays a welcome message on the root_path' do
    within '#container.container' do
      page.should have_css('h1', :text => 'Welcome')
    end
  end

  it 'displays flash alerts' do
    within '.alert.alert-success' do
      page.should have_content 'Welcome to YARB YetAnotherRubyBootstrap'
    end
  end

  it 'renders the REAMDE.md file with markdown' do
    within('article') do
      page.should have_css('h1', :text => 'HOW TO START')
    end
  end

  it 'renders a copyright message within the footer' do
    within('#footer') do
      within('.copyright') do
        page.should have_text('© 2013 by Andreas Altendorfer')
      end
    end
  end

end
