# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe "Run also" do
  it "is tested through SignUpController" do
    touch_dependency "app/models/user.rb", "controllers/sign_up_controller_spec.rb"
  end
end

describe User do

  before :all do
    I18n.locale = :en
  end

  before :each do
    User.delete_all!
    EmailConfirmation.delete_all!
  end

  let(:last_mail) { ActionMailer::Base.deliveries.last }

  it "requires a non-blank email" do
    u = User.new email: "", name: "me"
    expect(u.valid?).to be_false
    expect(u.errors.messages[:email]).to include("can't be blank")
  end

  it "doesn't allow duplicate emails" do
    u1 = User.create! email: "test@example.com", name: "Me"
    u2 = User.create email: "test@example.com", name: "Me"
    expect(u2.errors.any?).to be_true
    expect { User.create! email: "test@example.com" }.to raise_error UniquenessError
  end

  it "doesn't allow blank name" do
    user = User.create email: "test@example.com"
    expect(user.valid?).to be_false
    expect(user.errors.messages[:name]).to include("can't be blank")
  end

  it "has a single role" do
    u = User.new email: "admin@example.com", name: "Admin", roles: [:admin]
    expect(u.has_role?(:admin)).to be_true
    expect(u.has_role?(:root)).to be_false
  end

  it "has any of the given roles" do
    u = User.new email: "admin@example.com", name: "Admin", roles: [:admin, :guest, :author]
    expect(u.has_any_role?([:admin])).to be_true
    expect(u.has_any_role?([:guest, :author])).to be_true
    expect(u.has_any_role?([:undefined, :author])).to be_true
    expect(u.has_any_role?([:undefined, :nothing])).to be_false
  end

  it "creates an authentication entry on create" do
    u1 = User.create! email: "test@example.com", name: "Me"
    expect(Authentication.find_by(:user_id, u1.id)).not_to be_nil
  end

  it ".email_confirmed? is false for new users with identiy" do
    user = create_valid_user "test@example.com", "Tester", "secret"
    expect(user.email_confirmed?).to be_false
  end

  it ".confirmed_at is nil for unconfirmed emails" do
    user = create_valid_user "test@example.com", "Tester", "secret"
    expect(user.confirmed_at).to be_nil
  end

  it ".confirmed_at is a time in the current time-zone" do
    user = create_confirmed_user "test@example.com", "Tester", "secret"
    expect(user.confirmed_at).to be_a(Time)
  end

  it "creates a confirmation-request on create with identity" do
    user = create_valid_user "test@example.com", "Tester", "secret"
    expect(last_mail.subject).to eq("Please confirm your email address")
  end

  it ".email_confirmed? is true when confirmed_at is set" do
    user = create_confirmed_user "test@example.com", "Tester", "secret"
    expect(user.email_confirmed?).to be_true
  end

  it ".email_confirmed? is false when email changes" do
    user = create_confirmed_user "test@example.com", "Tester", "secret"
    expect(user.email_confirmed?).to be_true
    user.update_attributes email: "changed@example.com"
    expect(user.email_confirmed?).to be_false
  end

  describe '#create_edit_token!' do
    it 'saves a token in user#edit_token' do
      _user = create_confirmed_user "test@example.com", "Tester", "secret"
      expect(_user).to receive(:save)
      _user.create_edit_token!
      expect(_user.edit_token).not_to be_nil
    end
  end

  describe '#update_password_with_token' do
    let(:user) { create_confirmed_user "test@example.com", "Tester", "secret" }

    context 'with valid token' do
      it 'updates the password and removes the edit_token' do
        user.create_edit_token!
        _token = user.edit_token
        expect(user).to receive(:save)
        user.update_password_with_token!('123456', _token)

        expect(user.password).to eq('123456')
        expect(user.edit_token).to be_nil
      end
    end

    context 'with invalid token' do
      it 'raises an error' do
        expect { user.update_password_with_token!('123456', SecureRandom.hex) }.to raise_error('Unvalid Edit Token')
      end
    end
  end

  describe '.find_by_token' do
    let(:user) { create_confirmed_user "test@example.com", "Tester", "secret" }

    context 'with existing token' do
      it 'returns the User' do
        user.create_edit_token!
        _token = user.edit_token
        expect(User.find_by_token(_token).id).to eq(user.id)
      end
    end

    context 'with non-existing token' do
      it 'returns nil' do
        expect(User.find_by_token(SecureRandom.hex)).to be_nil
      end
    end
  end

end
