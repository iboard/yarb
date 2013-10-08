# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe SignUpInvitationsController do

  render_views

  before :all do
    User.delete_all!
    SignUpInvitation.delete_all!
    @admin = create_admin_user "admin@example.com", "Admin", "secret"
  end

  context "As a normal user" do
    it "should deny access" do
      visit new_sign_up_invitation_path
      page_should_have_error page, "Access denied"
    end
  end

  context "As an admin" do
    before :each do
      sign_in_as "admin@example.com", "secret"
    end

    let(:admin) { @admin }
    let(:last_mail)  { ActionMailer::Base.deliveries.last }

    it "renders a form if user is admin" do
      visit new_sign_up_invitation_path
      page.should have_field 'To'
      page.should have_field 'Message'
    end

    it "creates and sends an invitation" do
      visit new_sign_up_invitation_path
      fill_in 'To', with: "friend@example.com"
      fill_in 'Message', with: "Hello Friend"
      expect{
        click_button "Deliver"
      }.to change{ SignUpInvitation.all.count }.by(1)
      last_mail.from.first.should eq("admin@example.com")
      last_mail.to.first.should eq("friend@example.com")
      last_mail.body.should include("Hello Friend")
    end

    it "doesn't create an invitation if no email given" do
      visit new_sign_up_invitation_path
      fill_in 'Message', with: "Hello Friend"
      expect{
        click_button "Deliver"
      }.not_to change{ SignUpInvitation.all.count }.by(1)
    end

    it "doesn't create an invitation for invalid email" do
      visit new_sign_up_invitation_path
      fill_in 'Message', with: "Hello Friend"
      fill_in 'To', with: "not-an-email-example.com"
      expect{
        click_button "Deliver"
      }.not_to change{ SignUpInvitation.all.count }.by(1)
    end

    it "deletes an invitation" do
      invitation=SignUpInvitation.new( admin, "victim@example.com", message: "You'll be killed" )
      invitation.save
      visit sign_up_invitations_path
      expect{
        page.all("a", text: "Delete").last.click()
      }.to change{ SignUpInvitation.all.count }.by(-1)
    end
  end
end
