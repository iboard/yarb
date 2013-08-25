# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe Store do
  describe Store::Boolean do

    it "true-value is true" do
      t = Store::Boolean.new true
      expect(t).to be_true
    end

    it "true-value is not false" do
      t = Store::Boolean.new true
      expect(t).not_to be_false
    end


    it "false-value is false" do
      f = Store::Boolean.new false
      expect(f).to be_false
    end

    it "false-value is not true" do
      f = Store::Boolean.new false
      expect(f).not_to be_true
    end

    it "'false', '0', 'no', 'off', '' => false" do
      ['false', '0', 'no', 'off', ''].each do |s|
        expect( Store::Boolean.new s ).to be_false
      end
    end

    it "other strings are 'true'" do
      expect( Store::Boolean.new '1' ).to be_true
      expect( Store::Boolean.new 'true' ).to be_true
      expect( Store::Boolean.new 'on' ).to be_true
      expect( Store::Boolean.new 'yes' ).to be_true
      expect( Store::Boolean.new 'foo' ).to be_true
    end

  end
end

