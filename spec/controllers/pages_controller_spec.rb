require_relative '../spec_helper'

describe PagesController do
  
  render_views

  before :each do
    Page.delete_store!
    @page1 = Page.create( title: 'Page One', body: 'Body of page number one') 
    @page2 = Page.create( title: 'Page Two', body: 'Body of page number two') 
    @page_to_delete = Page.create( title: 'Delete Me', body: 'A victim page')
  end

  context 'with a list of pages' do
    let(:page1) { @page1 }
    let(:page2) { @page2 }
    let(:page_to_delete) { @page_to_delete }

    before :each do
      I18n.locale = :en
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

    it 'should have an add-page-link' do
      page.should have_link 'Add new page'
    end

    it 'saves new pages from form' do
      click_link 'Add new page'
      fill_in 'Title', with: 'A new page for testing'
      fill_in 'Body',  with: "Some Header\n=======\nAnd some text"
      click_button 'Save'
      should render_template 'show'
      page.should have_content 'A new page for testing'
    end

    it 'should display error for blank title' do
      click_link 'Add new page'
      fill_in 'Title', with: ''
      fill_in 'Body',  with: "Some Header\n=======\nAnd some text"
      click_button 'Save'
      should render_template 'new'
      page_should_have_error page, '× Page couldn\'t be saved.'
      page_should_have_error page, 'title: can\'t be blank'
    end

    it 'should display error for duplicate title' do
      Page.create title: 'I am the winner', body: "Some Header\n=======\nAnd some text"
      visit new_page_path
      fill_in 'Title', with: 'I am the winner'
      fill_in 'Body',  with: "Some Header\n=======\nAnd some text"
      click_button 'Save'
      page.should have_content 'An Object of class Page with key \'i-am-the-winner\' already exists.'
      should render_template 'new'
      fill_in 'Title', with: 'I am the loser'
      click_button 'Save'
      should render_template 'show'
      page.should have_content( 'I am the loser' )
      page.should have_content( "Some Header And some text" )
    end

    it 'response with 404 if page not found' do
      get :show, { controller: 'pages', id: 'not_existing_page_321' }
      expect(response.status).to eq(404)
    end

    it 'renders an error-message if page not found and shows index' do
      visit page_path('page_not_found')
      within '.alert-error' do
        page.should have_content("Page page_not_found doesn't exist")
      end
    end

    it 'can delete pages' do
      page.find('#page-delete-me a', text: 'Delete', match: :prefer_exact ).click()
      page_should_have_notice page, 'Page "Delete Me" successfully deleted.'
      Page.find('delete-me').should be_nil
    end

    it 'can edit a page' do
      page.find('#page-page-one a', text: 'Edit', match: :prefer_exact ).click()
      should render_template 'edit'
      fill_in 'Title', with: 'I am the first Page'
      fill_in 'Body', with: 'Loremsum firstum'
      click_button 'Save'
      should render_template 'index'
      page_should_have_notice page, 'Page successfully updated'
      Page.find('page-one').should be_nil
      page = Page.find('i-am-the-first-page')
      page.should_not be_nil
      page.body.should eq('Loremsum firstum')
    end

    it 'should not allow to store invalid pages on update' do
      _page = Page.create! title: 'I am valid', body: 'Valid page'
      visit edit_page_path(_page)
      fill_in 'Title', with: ''
      click_button 'Save'
      should render_template 'edit'
      page_should_have_error page, 'title: can\'t be blank'
    end

    it 'should not allow to update the key if it already exists' do
      Page.create! title: 'existing key', body: 'Do not touch'
      _page = Page.create! title: 'any key', body: 'Valid page'

      # First enter an invalid/existing key
      visit edit_page_path(_page)
      fill_in 'Title', with: 'existing key'
      click_button 'Save'
      should render_template 'edit'
      page_should_have_error page, 'base: title: existing-key already exists.'

      # Now enter another/valid key
      fill_in 'Title', with: 'another key'
      click_button 'Save'

      Page.find('existing-key').body.should eq('Do not touch')
      Page.find('any-key').should be_nil
      Page.find('another-key').body.strip.should eq('Valid page')
    end

  end

end


