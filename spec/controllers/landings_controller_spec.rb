require_relative '../spec_helper'

describe LandingsController do

  render_views

  before :each do
    visit root_path
  end

  it 'displays a welcome message on the root_path' do
    within '#container.container' do
      within 'h1' do
        page.should have_content 'Welcome'
      end
    end
  end

  it 'displays flash alerts' do
    within '.alert.alert-success' do
      page.should have_content 'Welcome to YARB YetAnotherRubyBootstrap'
    end

  end

end
