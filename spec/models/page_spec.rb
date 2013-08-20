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

end
