require_relative '../spec_helper'

describe ApplicationController do

  render_views

  before :each do
    visit root_path
  end

  it 'should switch locales' do
    within '#container.container' do
      page.should have_css('h1', :text => 'Welcome')
    end
    within 'footer .locales' do
      click_link 'Deutsch'
    end
    within '#container.container' do
      page.should have_css('h1', :text => 'Willkommen')
    end
  end

end
