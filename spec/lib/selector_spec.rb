# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe "Selector" do

  include Store

  class Selectable
    include Store
    key_method :id
    attribute  :id, type: Integer
    attribute  :value
    attribute  :character
    default_order :id, :asc
    attribute  :draft, type: Boolean
  end

  before :all do
    Selectable.delete_store!
    Selectable.create id: 0, value: 'Zero', character: 'a', draft: false
    Selectable.create id: 1, value: 'Two',  character: 'b', draft: true
    Selectable.create id: 2, value: 'Three',character: 'c', draft: true
    Selectable.create id: 3, value: 'Four', character: 'd', draft: false
    Selectable.create id: 4, value: 'Five', character: 'f', draft: false
  end

  it "selects all objects" do
    selector = Store::Selector.new Selectable, Selectable.send(:roots)
    expect(selector.all.map(&:id)).to eq(Selectable.all.map(&:id))
  end

  context "wraps the original class" do

    it "returns a Selector by calling .all()" do
      expect(Selectable.all).to be_an(Array)
    end

    it "returns a filtered Selector with .where()" do
      _result = Selectable.where( character: 'a' )
      expect(_result).to be_a(Store::Selector)
      expect(_result.all).to be_an(Array)
      expect(_result.first.id).to eq(0)
    end

    it "iterates over a result-set" do
      Selectable.where( value: 'Four' ).each do |rec|
        expect(rec).to be_a(Selectable)
        expect(rec.id).to eq(3)
      end
    end

    it "cascades .where()" do
      _first = Selectable.where(draft: false)
      _second = _first.where( id: 3 )
      expect(_first.count).to eq(3)
      expect(_second.first.value).to eq('Four')
    end

  end

end
