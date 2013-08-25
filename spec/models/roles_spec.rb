# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe Roles, "A module to be used in user-classes" do

  before :each do
    User.delete_all!
  end

  it "defines default roles in a constant (Roles::ROLES)" do
    expect( Roles::ROLES ).to be_an(Array)
  end

  context "A class including Roles" do

    class BClass
      include Store
      include Roles
    end

    let(:test_class) { new BClass }

    it "responds to has_role?()" do
      bc = BClass.new roles: %w( admin author )
      expect( bc.respond_to?(:has_role?) ).to be_true
      expect( bc.roles ).to eq( %w( admin author ) )
    end

    it "checks if any of the given roles is included in .roles()" do
      bc = BClass.new roles: %w( admin author )
      expect( bc.has_role?(:admin) ).to be_true
      expect( bc.has_role?("admin") ).to be_true
      expect( bc.has_role?(:author) ).to be_true
      expect( bc.has_role?("author") ).to be_true
      expect( bc.has_role?(:root) ).to be_false
      expect( bc.has_role?("root") ).to be_false
    end

  end

end
