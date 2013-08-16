require_relative '../spec_helper'

describe NilUser, 'A replacement for if current_user ....' do

  let(:user) { NilUser.new( name: 'dont care', email: 'no@where.at.all') }

  it 'initialize but throw away arguments' do
    expect( user.name ).to eq('(no name)')
    expect( user.email).to be_nil
  end

  it 'has no password' do
    expect( user.password ).to be_nil
  end

  it 'never authenticates' do
    expect( user.authenticate('whatever')).to be_false
  end

  it 'has no roles' do
    expect( user.roles ).to be_empty
  end

  it 'always answers no to has_role?' do
    expect( user.has_role?(:some) ).to be_false
  end

end
