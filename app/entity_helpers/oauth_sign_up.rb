# -*- encoding : utf-8 -*-"

# A non persistent model to collect sign-up information
class OAuthSignUp

  include  ActiveModel::Model
  extend   ActiveModel::Naming
  attr_accessor :uid, :provider, :name, :email, :invitation_token
  validates_presence_of :name
  validates_presence_of :email

  # Initializer
  # @param [Authentication] auth authentication object
  # @param [Hash] session session Hash
  # @return [OAuthSignUp]
  def initialize auth, session={}
    @provider = auth[:provider]
    @uid = auth[:uid]
    @name = auth[:info][:name]
    @email = auth[:info][:email]
    @invitation_token = session[:invitation_token]
  end


end
