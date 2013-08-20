# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe Page do

  before :all do
    I18n.locale = :en
  end

  it 'requires a non-blank title' do
    p = Page.new title: ''
    expect( p.valid? ).to be_false
    expect( p.errors.messages[:title] ).to include('can\'t be blank')
  end

  it 'doesn\'t allow duplicate titles' do
    p1 = Page.create! title: 'T One'
    p2 = Page.create  title: 'T One'
    expect( p2.errors.any? ).to be_true
    expect{ Page.create! title: 'T One' }.to raise_error DuplicateKeyError
  end

  context "Ordering" do

    before :all do
      Page.delete_store!
      @page1 = Page.create title: "First Created", position: 2
      @page2 = Page.create title: "Secondly Created Page", position: 3
      @page3 = Page.create title: "Last Created Page", position: 1
    end

    after(:all) { Page.delete_store! }

    let(:first ) { @page1 }
    let(:second) { @page2 }
    let(:third ) { @page3 }

    it ".asc as pushed if no field provided" do
      expect(Page.asc.map(&:position)).to eq( [2,3,1] )
    end

    it ".desc as pushed.reverse if no field provided" do
      expect(Page.desc.map(&:position)).to eq( [1,3,2] )
    end

    it "default order on all" do
      expect(Page.all.map(&:position)).to eq( [1,2,3] )
    end

    it "by creation date" do
      expect(Page.asc(:created_at).map(&:position)).to eq([2,3,1])
      expect(Page.desc(:created_at).map(&:position)).to eq([1,3,2])
    end

    it "by last update" do
      second.save
      expect(Page.asc(:updated_at).map(&:position)).to eq([2,1,3])
      expect(Page.desc(:updated_at).map(&:position)).to eq([3,1,2])
    end

  end
end
