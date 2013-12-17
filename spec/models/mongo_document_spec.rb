# -*- encoding : utf-8 -*-"

require "spec_helper"


describe "Connection to MongoDB using MongoId gem" do

  class MyDocument
    include Mongoid::Document
    field :name

  end
  it "stores a simple document" do
    expect {
      MyDocument.create( name: "Dummy" )
    }.to change( MyDocument, :count ).by(1)
  end


end
