# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe NilUser, "(A replacement for current_user == nil)" do

  let(:user) { NilUser.new( name: "dont care", email: "no@where.at.all") }

  it "initialize and throws away arguments" do
    expect( user.name ).to eq("(no name)")
    expect( user.email).to be_nil
  end

  it "has no password" do
    expect( user.password ).to be_nil
  end

  it "never authenticates" do
    expect( user.authenticate("whatever")).to be_false
  end

  it "has no roles" do
    expect( user.roles ).to be_empty
  end

  it "always answers no to has_role?" do
    expect( user.has_role?(:some) ).to be_false
  end

  it "always return an empty array to has_any_role?" do
    expect( user.has_any_role?([:some,:other])).to be_false
  end
end
