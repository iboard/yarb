# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe Store do

  it "uses db/:env/ to store files." do
    expect( Store::path ).to eq( File.join( Rails.root, "db", Rails.env ) )
  end

  context "used in any class" do

    class MyStoreClass
      include Store
      key_method :my_field
      attribute  :my_field
      attribute  :my_other_field, type: String, default: "with a default"

      def initialize _my_field
        @my_field = _my_field
      end
    end

    let(:object) { MyStoreClass.new("my object") }

    it "saves data in it's own path named by the class-name" do
       expect( object.send(:store_path) ).to eq(
         File.join(Store::path, "my_store_class" )
       )
    end

    it "finds entries by keys" do
      object.save
      read_object = MyStoreClass.find( object.key )
      expect(read_object.my_field).to eq(object.my_field)
    end

    it "can tell either an object is saved/persistent with new_record?()" do
      obj = MyStoreClass.new "A new Record"
      obj.new_record?.should be_true
      obj.save
      obj.new_record?.should be_false
      obj2 = MyStoreClass.find "a-new-record"
      obj2.new_record?.should be_false
    end

    it "calls the callback 'loaded' after read from file" do
      obj = MyStoreClass.new "Load me"
      obj.save
      MyStoreClass.any_instance.should_receive(:after_load).once
      obj_reloaded = MyStoreClass.find "load-me"
    end

    it "deletes the entire file with 'delete_store!()'" do
      object.save
      MyStoreClass.delete_store!
      expect( File.exist?(MyStoreClass.send(:store_path)) ).to be_false
    end

    it "deletes single entries with object.delete()" do
      object.save
      expect( MyStoreClass.find(object.key) ).to_not be_nil
      object.delete
      expect( MyStoreClass.find(object.key) ).to be_nil
    end

    context "Single object operations" do

      before :each do
        @object = MyStoreClass.find("object-to-test") || MyStoreClass.create( "object to test")
      end

      it "defines attributes for the class" do
        expect( @object.attributes).to eq( [
          { my_field: "object to test" }, { my_other_field: "with a default" }
        ] )
      end

      it "defines attribute getters for each attribute" do
        expect( @object.my_field ).to eq( "object to test" )
        expect( @object.my_other_field ).to eq( "with a default" )
        expect( @object.default_of(:my_other_field)).to eq("with a default")
      end

      it "validates uniqueness of key-field" do
        MyStoreClass.exist?(@object.key).should be_true
        MyStoreClass.exist?("not-available-key").should be_false
      end

      it "adds an error if not unique" do
        MyStoreClass.exist?(@object.key).should be_true
        duplication = MyStoreClass.create @object.key
        expect( duplication.errors[:base].first ).to match( "already exists." )
      end

      it "allows to change the key of an object" do
        obj = MyStoreClass.find("object-to-test")
        obj.my_field = "Object tested"
        obj.save
        MyStoreClass.find("object-to-test").should be_nil
        MyStoreClass.find("object-tested").should_not be_nil
      end

      context "Dirty tracking" do
        it "tracks updated attributes" do
          object.my_other_field = "Changed"
          expect(object.modified_attributes).to eq([:my_other_field])
        end
      end
    end

    context "With a collection of object" do

      before :each do
        MyStoreClass.delete_store!
        @object1 = MyStoreClass.create("First Object")
        @object2 = MyStoreClass.create("Second Object")
      end

      it "lists the keys of each object" do
        expect(MyStoreClass.keys).to eq(["first-object", "second-object"])
      end

      it "throws an exception on .create!() if key exists" do
        expect { MyStoreClass.create!("First Object") }
        .to raise_error DuplicateKeyError,
            "An object of class MyStoreClass "          +
            "with key 'first-object' already exists."
      end

      it "doesn't throw an exception but sets errors on .create() if key exists" do
        _p = MyStoreClass.create("First Object")
        expect( _p.errors.messages ).to eq(
          base: [ "An object of class MyStoreClass with key 'first-object' " +
                  "already exists." ]
        )
      end

      it "retrieves all objects with .all()" do
        expect(MyStoreClass.all.map(&:my_field)).to eq( [@object1.my_field,@object2.my_field] )
      end
    end
  end

  context "Ordering" do

    class SortableObject
      include Store
      key_method    :position
      attribute     :position, type: Integer
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

    after(:each) { SortableObject.delete_store! }

    it "sorts .asc(:attribute)" do
      expect( SortableObject.asc(:position).map(&:position)).to eq( [ 1, 2, 3 ] )
    end

    it "sorts .desc(:attribute)" do
      expect( SortableObject.desc(:position).map(&:position)).to eq( [ 3, 2, 1 ] )
    end

    it "sorts by default as defined with default_order" do
      expect( SortableObject.all.map(&:position)).to eq( [ 3, 2, 1 ] )
    end

    it "returns objects as pushed on .asc() without attribute" do
      expect( SortableObject.asc.map(&:position)).to eq( [ 3, 1, 2 ] )
    end

    it "returns in reverse order .desc() without attribute" do
      expect( SortableObject.desc.map(&:position)).to eq( [ 2, 1, 3 ] )
    end

    it "compares as string when data-types are different" do
      SortableObject.create!(position: "As String")
      expect{ SortableObject.asc(:position) }.not_to raise_error
    end
  end

  context "Selecting" do
    class TestPage
      include Store
      key_method :title
      attribute  :title
      attribute  :draft, type: Boolean, default: true
    end

    before :all do
      TestPage.delete_store!
      @p1 = TestPage.create title: "is online", draft: false
      @p2 = TestPage.create title: "is a draft"
    end

    it "filters by a single attribute with .where(:a => value)" do
      expect(TestPage.where( draft: false).map(&:title)).to include( "is online" )
      expect(TestPage.where( draft: false).map(&:title)).not_to include( "is a draft" )
      expect(TestPage.where( draft: true ).map(&:title)).to include("is a draft" )
      expect(TestPage.where( draft: true ).map(&:title)).not_to include("is online")
    end

    it "filters with more arguments .where(:a => value, :b => value) (AND)" do
      expect(TestPage.where( draft: false, title: "is online").map(&:title)).
        to include("is online")
      expect(TestPage.where( draft: true, title: "is online").map(&:title)).
        to be_empty
    end
  end
end
