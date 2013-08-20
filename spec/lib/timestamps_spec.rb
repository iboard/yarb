# -*- encoding : utf-8 -*-
require_relative '../spec_helper'
require_relative '../../lib/store/store'

describe Store::Timestamps do

  it "throws an exception if class doesn't include Store" do
    expect{
      class NonStoreObject
        include Store::Timestamps
      end
    }.to raise_error( Store::NonStoreObjectError )
  end

  it "loads module correctly if store is included" do
    expect{
      class StoreObject
        include Store
        include Store::Timestamps
      end
    }.not_to raise_error
  end

  context 'with a store-object' do
    class MyObject
      include Store
      include Store::Timestamps
      key_method :id
      attribute :id
      attribute :name
      attr_accessor :name
    end

    it "sets created_at and updated_at when saving" do
      object = MyObject.new( name: 'First Object' )
      expect( object.created_at ).to be_nil
      expect( object.updated_at ).to be_nil
      object.save
      expect( object.created_at ).to be_a(Time)
      expect( object.updated_at ).to be_a(Time)
      object.delete
    end

    it "updates updated_at at save but leaves created_at on save" do
      object = MyObject.create!( name: 'First Object' )
      expect( object.created_at ).to eq( object.updated_at )
      object.update_attributes( { created_at: Time.now - 1.week } )
      expect( (object.updated_at - object.created_at).to_i ).to eq( 1.week.to_i )
    end

  end

end
