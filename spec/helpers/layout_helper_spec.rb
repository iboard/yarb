# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe LayoutHelper do

  it 'maps locales with block' do
    expect( join_all_locales(';'){|l| l.upcase}).to eq('EN;DE')
  end

  it 'maps locales without block' do
    expect( join_all_locales(';')).to eq('en;de')
  end

end
