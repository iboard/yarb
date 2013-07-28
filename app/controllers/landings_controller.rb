# The LandingsController is the root_path of the application.
# It welcomes new visitors, and, in further versions displays
# Login, News, and other stuff a visitor should see when landing
# on our site.
class LandingsController < ApplicationController

  # GET /
  def index
    flash[:notice] = t('flash_messages.welcome')
  end
end
