# The LandingsController is the root_path of the application.
# It welcomes new visitors, and, in further versions displays
# Login, News, and other stuff a visitor should see when landing
# on our site.
class LandingsController < ApplicationController

  # The REAMDE.md is displayed on the Landing-page
  README_FILE = File.expand_path('../../../README.md',__FILE__) 

  # GET /
  def index
    flash[:notice] ||= t('flash_messages.welcome')
    @readme = File.read( README_FILE )
  end
end
