# -*- encoding : utf-8 -*-"

require_relative "../spec_helper"


describe UserPresenter do

  before :each do
    User.delete_store!
    EmailConfirmation.delete_store!
  end

  let(:view)       { ActionView::Base.new }
  let(:last_mail)  { ActionMailer::Base.deliveries.last }

  it ".confirmed_at is nil for unconfirmed emails" do
    user = create_valid_user "test@example.com", "Tester", "secret"
    p = UserPresenter.new(user, view)
    expect( p.email_confirmed_at ).to match("Not confirmed yet")
  end

  it ".confirmed_at is a time in the current time-zone" do
    user = create_confirmed_user "test@example.com", "Tester", "secret"
    p = UserPresenter.new(user, view)
    expect( p.email_confirmed_at ).to match(/#{user.confirmed_at}/)
  end

end
