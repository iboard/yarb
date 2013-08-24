# -*- encoding : utf-8 -*-
require_relative '../spec_helper'
require_relative '../../lib/store/store'

describe Store::Timestamps do

  it "ensures module Store is included" do
    expect{
      class NonStoreObject
        include Store::Timestamps
      end
    }.to raise_error( Store::NonStoreObjectError )
  end

  it "loads module with store included" do
    expect{
      class StoreObject
        include Store
        include Store::Timestamps
      end
    }.not_to raise_error
  end

  context 'Object' do
    class MyObject
      include Store
      include Store::Timestamps
      key_method :id
      attribute :id
      attribute :name
      attr_accessor :name
    end

    it "updates timestamps on save" do
      object = MyObject.new( name: 'First Object' )
      expect( object.created_at ).to be_nil
      expect( object.updated_at ).to be_nil
      object.save
      expect( object.created_at ).to be_a(Time)
      expect( object.updated_at ).to be_a(Time)
      object.delete
    end

    it "doesn't overwrite created_at" do
      object = MyObject.create!( name: 'First Object' )
      expect( object.created_at ).to eq( object.updated_at )
      object.update_attributes( { created_at: Time.now - 1.week } )
      object.created_at.should be_within(1).of(Time.now-1.week)
      object.delete
    end

    context "Timestamps" do

      before(:all) { @object = MyObject.create( id: 1, name: "Test Bunny") }
      after(:all)  { MyObject.delete_store! }

      before :each do
        PStore.any_instance.stub(:transaction)
        allow_message_expectations_on_nil
      end

      it "on save" do
        expect(@object).to receive(:update_timestamps)
        @object.save
      end

      it "ignores updated_at if modified before" do
        ts = Time.now - 1.week
        @object.updated_at = ts
        @object.save
        @object.updated_at.to_i.should be_within(1).of(ts.to_i)
      end

    end

  end

end
