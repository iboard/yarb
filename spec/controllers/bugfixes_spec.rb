# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe "Specs for high-level bugfixes" do

  describe PagesController do
    render_views

    it "should not crash with markdown if body is nil" do
      page = Page.create! title: "with empty body"
      expect{ visit page_path(page) }.not_to raise_error
    end

  end
end

