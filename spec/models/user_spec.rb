require_relative '../spec_helper'

describe User do

  before :all do
    I18n.locale = :en
  end

  before :each do
    User.delete_all!
  end

  it 'requires a non-blank email' do
    u = User.new email: '', name: 'me'
    expect( u.valid? ).to be_false
    expect( u.errors.messages[:email] ).to include('can\'t be blank')
  end

  it 'doesn\'t allow duplicate emails' do
    u1 = User.create! email: 'test@example.com', name: 'Me'
    u2 = User.create  email: 'test@example.com', name: 'Me'
    expect( u2.errors.any? ).to be_true
    expect{ User.create! email: 'test@example.com' }.to raise_error DuplicateKeyError
  end

  it "doesn't allow blank name" do
    user = User.create email: 'test@example.com'
    expect( user.valid? ).to be_false
    expect( user.errors.messages[:name] ).to include('can\'t be blank')
  end

  it "has roles" do
    u = User.new email: 'admin@example.com', name: 'Admin', roles: %i(admin)
    expect(u.has_role?(:admin)).to be_true
    expect(u.has_role?(:root)).to be_false
  end

end
