# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe Roles, 'A module to be used in user-classes' do

  before :each do
    User.delete_all!
  end

  it 'defines the ROLES-array' do
    expect( Roles::ROLES ).to be_an(Array)
  end

  context 'with a dummy class' do

    class BClass
      include Store
      include Roles
    end

    let(:test_class) { new BClass }

    it 'injects a roles-field to the base-class' do
      bc = BClass.new roles: %w( admin author )
      expect( bc.respond_to?(:has_role?) ).to be_true
      expect( bc.roles ).to eq( %w( admin author ) )
    end

    it '.has_role?(xxx) reports true/false' do
      bc = BClass.new roles: %w( admin author )
      expect( bc.has_role?(:admin) ).to be_true
      expect( bc.has_role?('admin') ).to be_true
      expect( bc.has_role?(:author) ).to be_true
      expect( bc.has_role?('author') ).to be_true
      expect( bc.has_role?(:root) ).to be_false
      expect( bc.has_role?('root') ).to be_false
    end

  end

end
