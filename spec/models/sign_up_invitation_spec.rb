# -*- encoding : utf-8 -*-"


require_relative "../spec_helper"

describe SignUpInvitation do

  before :all do
    @sender = create_admin_user 'host@example.com', 'Host', 'secret'
  end

  let(:sender) { @sender }
  let(:receiver) { "guest@example.com" }
  let(:options) { { message: 'Welcome', subject: "You're invited",  roles: [:confirmed] } }

  it "initialize with sender, receiver, and options" do
    expect( SignUpInvitation.new( sender, receiver, options ) ).not_to be_nil
  end

  context "before it's delivered" do

    before :each do
      SignUpInvitation.delete_all!
      @invitation = SignUpInvitation.new( sender, receiver, options )
      @invitation.save
    end

    let(:invitation) { @invitation }

    it "has all attributes to send an email" do
      expect( invitation.sender.name ).to eq( "Host" )
      expect( invitation.from ).to eq( "host@example.com" )
      expect( invitation.to ).to eq( "guest@example.com" )
      expect( invitation.subject ).to eq( "You're invited" )
      expect( invitation.message ).to eq( "Welcome" )
    end

    it "has a valid token" do
      expect( invitation.token ).to match( /\A[a-f0-9]{8}-[0-9a-f]{8}\Z/ )
    end

  end

  describe "delivering invitation" do

    before :each do
      SignUpInvitation.delete_all!
      @invitation = SignUpInvitation.new( sender, receiver, options )
      @invitation.save
    end

    let(:invitation) { @invitation }
    let(:last_mail)  { ActionMailer::Base.deliveries.last }

    it "sends an email to receiver" do
      invitation.deliver
      expect( last_mail.from ).to include( invitation.from )
      expect( last_mail.to ).to include( invitation.to )
      expect( last_mail.subject ).to eq( invitation.subject )
      expect( last_mail.body ).to include( invitation.message )
    end

    it "includes the correct link to accept the invitation" do
      pending "refactor Settings first"
      assert false, "not implemented yet"
    end
  end


end
