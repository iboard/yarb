# -*- encoding : utf-8 -*-"

# A non persistent model to collect sign-up information
class OAuthSignUp

  include  ActiveModel::Model
  extend   ActiveModel::Naming
  attr_accessor :uid, :provider, :name, :email
  validates_presence_of :name
  validates_presence_of :email

  def initialize auth
    @provider = auth[:provider]
    @uid = auth[:uid]
    @name = auth[:info][:name]
    @email = auth[:info][:email]
  end


end
