# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe Store do

  it 'uses path for current environment' do
    expect( Store::path ).to eq( File.join( Rails.root, 'db', Rails.env ) )
  end

  context 'included in any class' do

    class MyClass
      include Store
      key_method :my_field
      attribute  :my_field
      attribute  :my_other_field, 'with a default'

      def initialize _my_field
        @my_field = _my_field
      end
    end

    let(:object) { MyClass.new('my object') }

    it 'uses the name of the base-class for pstore-files' do
       expect( object.send(:store_path) ).to eq( File.join(Store::path, 'my_class' ) )
    end

    it 'saves and retrieves an object from the store' do
      object.save
      read_object = MyClass.find( object.key )
      expect(read_object.my_field).to eq(object.my_field)
    end

    it 'reports new_record? if object is not saved or loaded from store yet' do
      obj = MyClass.new 'A new Record'
      obj.new_record?.should be_true
      obj.save
      obj.new_record?.should be_false
      obj2 = MyClass.find 'a-new-record'
      obj2.new_record?.should be_false
    end

    it 'calls callback loaded after loading the object from the store' do
      obj = MyClass.new 'Load me'
      obj.save
      MyClass.any_instance.should_receive(:after_load).once
      obj_reloaded = MyClass.find 'load-me'
    end

    it 'deletes the store' do 
      object.save
      MyClass.delete_store!
      expect( File.exist?(MyClass.send(:store_path)) ).to be_false
    end

    it 'deletes an entry from the store' do
      object.save
      expect( MyClass.find(object.key) ).to_not be_nil
      object.delete
      expect( MyClass.find(object.key) ).to be_nil
    end

    context 'with a single object' do

      before :each do
        @object = MyClass.find('object-to-test') || MyClass.create( 'object to test')
      end

      it 'implements attributes method' do
        expect( @object.attributes).to eq( [ 
          { my_field: 'object to test' }, { my_other_field: 'with a default' } 
        ] )

        expect( @object.my_field ).to eq( 'object to test' )
        expect( @object.my_other_field ).to eq( 'with a default' )
        expect( @object.default_of(:my_other_field)).to eq('with a default')
      end

      it 'can check if key exists' do
        MyClass.exist?(@object.key).should be_true
        MyClass.exist?('not-available-key').should be_false
      end

      it 'can delete objects by key' do
        new_object = MyClass.create!( 'short living object' )
        MyClass.find('short-living-object').should_not be_nil
        MyClass.delete('short-living-object')
        MyClass.find('short-living-object').should be_nil
      end

      it 'should change the key' do
        obj = MyClass.find('object-to-test')
        obj.my_field = 'Object tested'
        obj.save
        MyClass.find('object-to-test').should be_nil
        MyClass.find('object-tested').should_not be_nil
      end

    end

    context 'with two objects' do
      before :each do
        MyClass.delete_store!
        @object1 = MyClass.create('First Object')
        @object2 = MyClass.create('Second Object')
      end

      it 'creates and lists available objects' do
        expect(MyClass.keys).to eq(['first-object', 'second-object'])
      end

      it '.create! throws an exception on duplicate keys' do
        expect { MyClass.create!('First Object') }.
          to raise_error DuplicateKeyError, 'An object of class MyClass with key \'first-object\' already exists.'
      end

      it '.create returns an invalid object on duplicate keys' do
        _p = MyClass.create('First Object')
        expect( _p.errors.messages ).to eq(base:["An object of class MyClass with key 'first-object' already exists."] )
      end

      it 'loads all objects' do
        expect(MyClass.all.map(&:my_field)).to eq( [@object1.my_field,@object2.my_field] )
      end
    end
  end

  context "Ordering" do

    context "with default order" do

      class SortableObject
        include Store
        key_method    :position
        attribute     :position
        default_order :position, :desc
        attr_accessor :position
      end

      before :each do 
        @objects = [
          SortableObject.create!(position: 3),
          SortableObject.create!(position: 1),
          SortableObject.create!(position: 2),
        ]
      end

      after(:each) { @objects.each(&:delete) }

      it "sorts ascending" do
        expect( SortableObject.asc(:position).map(&:position)).to eq( [ 1, 2, 3 ] )
      end

      it "sorts descending" do
        expect( SortableObject.desc(:position).map(&:position)).to eq( [ 3, 2, 1 ] )
      end

      it "sorts by default" do
        expect( SortableObject.all.map(&:position)).to eq( [ 3, 2, 1 ] )
      end

      it "sorts as pushed on asc without field" do
        expect( SortableObject.asc.map(&:position)).to eq( [ 3, 1, 2 ] )
      end
  
      it "reverse sorts as pushed on desc without field" do
        expect( SortableObject.desc.map(&:position)).to eq( [ 2, 1, 3 ] )
      end
    end

  end

end
