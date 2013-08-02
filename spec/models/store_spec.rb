require_relative '../spec_helper'

describe Store do

  it 'uses path for current environment' do
    expect( Store::path ).to eq( File.join( Rails.root, 'db', Rails.env ) )
  end

  context 'included in any class' do

    before :all do
      class MyClass < Struct.new(:my_field)
        include Store
      end
    end

    it 'uses the name of the base-class for pstore-files' do
       expect( MyClass.new('xxx').store_path ).to eq( File.join(Store::path, 'my_class' ) )
    end

    it 'stores the class data in the class-path' do
      object = MyClass.new('my data')
      object.save
      expect( File.exist?( File.join( object.store_path, "#{object.class.to_s.underscore}.pstore" ) ) ).to be_true
    end

  end

end
