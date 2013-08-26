require_relative '../spec_helper'

#include Store

#describe Selector do

  #class Selectable
    #include Store
    #key_method :id
    #attribute  :id, type: Integer
    #attribute  :value
    #attribute  :character
    #default_order :id, :asc
  #end

  #before :all do
    #Selectable.delete_store!
    #Selectable.create id: 0, value: 'Zero', character: 'a'
    #Selectable.create id: 1, value: 'Two',  character: 'b'
    #Selectable.create id: 2, value: 'Three',character: 'c'
    #Selectable.create id: 3, value: 'Four', character: 'd'
    #Selectable.create id: 4, value: 'Five', character: 'f'
  #end

  #it "selects all objects" do
    #selector = Selector.new Selectable, Selectable.roots
    #expect(selector.all.map(&:id)).to eq(Selectable.all.map(&:id))
  #end

  #context "Any Store-object" do

    #it "returns a Selector by calling .all()" do
      #expect(Selectable.all).to be_an(Array)
    #end

  #end

#end
