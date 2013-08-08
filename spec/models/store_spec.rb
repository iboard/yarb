require_relative '../spec_helper'

describe Store do

  it 'uses path for current environment' do
    expect( Store::path ).to eq( File.join( Rails.root, 'db', Rails.env ) )
  end

  context 'included in any class' do

    class MyClass
      include Store
      key_method :my_field

      attr_reader :my_field

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
          to raise_error DuplicateKeyError, 'An Object of class MyClass with key \'first-object\' already exists.'
      end

      it '.create returns an invalid object on duplicate keys' do
        _p = MyClass.create('First Object')
        expect( _p.errors.messages ).to eq(base:["An Object of class MyClass with key 'first-object' already exists."] )
      end

      it 'loads all objects' do
        expect(MyClass.all.map(&:my_field)).to eq( [@object1.my_field,@object2.my_field] )
      end
    end
  end

end
