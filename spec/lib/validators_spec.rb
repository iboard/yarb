require_relative '../spec_helper'

describe "Validators" do

  context Store::Validator do
    it "always returns true" do
      v = Store::Validator.new( :field, :object )
      expect( v.validate( {} ) ).to be_true
    end
  end

  it "are covered by store-specs" do
    # Make sure guard will run them
    expect(
      cover_source_by(
        "lib/store/validators.rb",
        "lib/store_spec.rb"
      )
    ).to be_true
  end

end

