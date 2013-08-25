# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe PagesController do
  
  render_views

  before :each do
    Page.delete_store!
    @page1 = Page.create( title: "Page One", body: "Body of page number one", position: 3, draft: false) 
    @page2 = Page.create( title: "Page Two", body: "Body of page number two", position: 1, draft: false) 
    @page_to_delete = Page.create( title: "Delete Me", body: "A victim page", position: 2, draft: false)
    @draft = Page.create( title: "Draft by default", body: "A Draft ...",     position: 4 )
  end

  context "with a list of pages" do
    let(:page1) { @page1 }
    let(:page2) { @page2 }
    let(:page_to_delete) { @page_to_delete }
    let(:draft) { @draft }

    before :each do
      I18n.locale = :en
      visit pages_path
    end

    it "lists available pages" do
      within "#container.container" do
        page.should have_css("h1", :text => "Available Pages")
        page.should have_css("li#page-page-one", :text => "Page One")
        page.should have_css("li#page-page-two", :text => "Page Two")
      end
    end


    it "lists all md-files from project-root as links" do
      within "#container.container" do
        Dir[File.join(Rails.root,"*.md")].each do |file|
          _fname = File.basename(file,".md").downcase
          _title = _fname.upcase
          within "li#page-#{_fname}" do
            page.should have_link( _title )
          end
        end
      end
    end

    it "shows md-pages" do
      within "li#page-store" do
        click_link "STORE"
      end
      within "article" do
        page.should have_text( "How the Store-Module works" )
      end
    end

    context "with different user roles" do
      before :all do 
        User.delete_all!
        Roles::ROLES.each do |role|
          user = User.create name: role.to_s.humanize, email: "#{role.to_s}@example.com", roles: [role]
          user.password = "secret"
          user.save
        end
      end

      before :each do
        sign_out
      end

      after :each do
        sign_out
      end

      it "has an add-page-link for PAGE_CREATOR_ROLES" do
        page.should_not have_link "Add new page"
        PagesController::PAGE_CREATOR_ROLES.each do |role|
          sign_in_as "#{role}@example.com", "secret"
          click_link "Pages"
          page.should have_link "Add new page"
        end
      end

      it "has an edit-page-link for PAGE_EDITOR_ROLES" do
        page.should_not have_css("a.btn-primary:contains('Edit')")
        PagesController::PAGE_EDITOR_ROLES.each do |role|
          sign_in_as "#{role}@example.com", "secret"
          click_link "Pages"
          page.should match_at_least(1, "a.btn-primary:contains('Edit')" )
        end
      end

      it "lists draft-pages for PAGE_EDITOR_ROLES only" do
        within "#container.container" do
          page.should_not have_css("li#page-draft-by-default", :text => "Draft by default")
        end
        PagesController::PAGE_EDITOR_ROLES.each do |role|
          sign_in_as "#{role}@example.com", "secret"
          click_link "Pages"
          page.should match_at_least(1, "a.btn-primary:contains('Edit')" )
          within "#container.container" do
            page.should have_css("li#page-draft-by-default", :text => "Draft by default")
          end
        end
      end

      it "has a delete-page-link for PAGE_TERMINATOR_ROLES" do
        page.should_not have_css("a.btn-danger:contains('Delete')")
        PagesController::PAGE_TERMINATOR_ROLES.each do |role|
          sign_in_as "#{role}@example.com", "secret"
          click_link "Pages"
          page.should match_at_least(1, "a.btn-danger:contains('Delete')" )
          sign_out
        end
      end

      context "as admin"  do

        before :each do
          sign_in_as "admin@example.com", "secret"   
          visit pages_path
        end

        after :each do
          sign_out
        end

        it "saves new pages from form" do
          click_link "Add new page"
          fill_in "Title", with: "A new page for testing"
          fill_in "Body",  with: "Some Header\n=======\nAnd some text"
          click_button "Save"
          should render_template "show"
          page.should have_content "A new page for testing"
        end

        it "displays error for blank title" do
          click_link "Add new page"
          fill_in "Title", with: ""
          fill_in "Body",  with: "Some Header\n=======\nAnd some text"
          click_button "Save"
          should render_template "new"
          page_should_have_error page, "× Page couldn't be saved."
          page_should_have_error page, "title: can't be blank"
        end

        it "displays error for duplicate title" do
          Page.create title: "I am the winner", body: "Some Header\n=======\nAnd some text"
          visit new_page_path
          fill_in "Title", with: "I am the winner"
          fill_in "Body",  with: "Some Header\n=======\nAnd some text"
          click_button "Save"
          page.should have_content "An object of class Page with key 'i-am-the-winner' already exists."
          should render_template "new"
          fill_in "Title", with: "I am the loser"
          click_button "Save"
          should render_template "show"
          page.should have_content( "I am the loser" )
          page.should have_content( "Some Header And some text" )
        end

        it "responds with 404-status if page not found" do
          get :show, { controller: "pages", id: "not_existing_page_321" }
          expect(response.status).to eq(404)
        end

        it "renders an error-message if page not found and shows index" do
          visit page_path("page_not_found")
          within ".alert-error" do
            page.should have_content("Page page_not_found doesn't exist")
          end
        end

        it "deletes pages"  do
          page.find("#page-delete-me a", text: "Delete", match: :prefer_exact ).click()
          page_should_have_notice page, "Page \"Delete Me\" successfully deleted."
          Page.find("delete-me").should be_nil
        end

        it "saves modifications" do
          page.find("#page-page-one a", text: "Edit", match: :prefer_exact ).click()
          should render_template "edit"
          fill_in "Title", with: "I am the first Page"
          fill_in "Body", with: "Loremsum firstum"
          click_button "Save"
          should render_template "index"
          page_should_have_notice page, "Page successfully updated"
          Page.find("page-one").should be_nil
          page = Page.find("i-am-the-first-page")
          page.should_not be_nil
          page.body.should eq("Loremsum firstum")
        end

        it "doesn't store invalid pages on update" do
          _page = Page.create! title: "I am valid", body: "Valid page"
          visit edit_page_path(_page)
          fill_in "Title", with: ""
          click_button "Save"
          should render_template "edit"
          page_should_have_error page, "title: can't be blank"
        end

        it "doesn't allow to update the key if it already exists" do
          Page.create! title: "existing key", body: "Do not touch"
          _page = Page.create! title: "any key", body: "Valid page"

          # First enter an invalid/existing key
          visit edit_page_path(_page)
          fill_in "Title", with: "existing key"
          click_button "Save"
          should render_template "edit"
          page_should_have_error page, "base: title: existing-key already exists."

          # Now enter another/valid key
          fill_in "Title", with: "another key"
          click_button "Save"

          Page.find("existing-key").body.should eq("Do not touch")
          Page.find("any-key").should be_nil
          Page.find("another-key").body.strip.should eq("Valid page")
        end

        it "doesn't show delete-button if page.new?" do
          visit new_page_path
          page.should_not have_link("Delete")
        end

      end
    end

    context "sort with drag and drop", js:true do
      before :all do
        user = User.create name: "Sorter", email: "sorter@example.com"
        user.roles += PagesController::PAGE_EDITOR_ROLES
        user.password = "sortit"
        user.save
      end

      before :each do
        sign_in_as "sorter@example.com", "sortit"
        visit pages_path
      end

      it "saves new positions" do
        within("#pages-list") do 
          # check order as given in before each
          text.should match /Page Two.*Delete Me.*Page One/ 
        end
        last_page = find("#page-page-one")
        first_page = find("#page-page-two")
        last_page.drag_to first_page

        # TODO: Get rid of this sleep!
        sleep 0.5 # let the post-request finish it's work
        visit pages_path
        within("#pages-list") do 
          text.should match /Page One.*Page Two.*Delete Me/
        end
      end
    end

  end
end


