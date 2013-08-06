require_relative '../spec_helper'

describe Page do

  before :each do
    I18n.locale = :en
  end

  it 'requires a non-blank title' do
    p = Page.new title: ''
    expect( p.valid? ).to be_false
    expect( p.errors.messages[:title] ).to include('can\'t be blank')
  end

  it 'doesn\'t allow duplicate titles' do
    p1 = Page.create title: 'T One'
    expect { Page.create title: 'T One' }.to raise_error DuplicateKeyError
  end

end
