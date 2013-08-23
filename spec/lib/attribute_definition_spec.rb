# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe Store do
  describe Store::AttributeDefinition do

    class MyClass
      include Store
      key_method :id
      attribute  :id
      attribute  :string_field
      attribute  :another_string
      attribute  :string_with_default, default: "string"
      attribute  :integer_with_default, type: Integer, default: 0
      attribute  :nil_boolean, type: Boolean
      attribute  :default_true, type: Boolean, default: true
      attribute  :set_boolean,  type: Boolean
      attribute  :str_boolean_true,  type: Boolean, default: "1"
      attribute  :str_boolean_false,  type: Boolean, default: "0"
      attribute  :int_boolean_true,  type: Boolean, default: 1
      attribute  :int_boolean_false,  type: Boolean, default: 0
    end

    let(:object) { 
      MyClass.new( id: 0, 
                  another_string: "A String", 
                  set_boolean: true,
                 ) 
    }

    it "default string is nil" do
      expect( object.string_field ).to be_nil
    end

    it "returns string when set" do
      expect( object.another_string ).to eq("A String")
    end

    it "returns the default if given" do
      expect( object.string_with_default ).to eq("string")
    end

    it "returns an Integer with default" do
      expect( object.integer_with_default ).to eq(0)
    end

    it "returns a Boolean w/o default as nil" do
      expect( object.nil_boolean ).to be_nil
    end

    it "returns a Boolean with default true as true" do
      expect( object.default_true ).to be_true
    end

    it "returns a Boolean as initialized at new" do
      expect( object.set_boolean ).to be_true
    end
    
    it "returns a boolean initialized with 1 as true" do
      expect( object.int_boolean_true ).to be_true
    end

    it "returns a boolean initialized with 0 as false" do
      expect( object.int_boolean_false).to be_false
    end

    it "returns a boolean initialized with '1' as true" do
      expect( object.str_boolean_true ).to be_true
    end

    it "returns a boolean initialized with '0' as false" do
      expect( object.str_boolean_false).to be_false
    end

  end
end
