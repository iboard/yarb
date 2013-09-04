# -*- encoding : utf-8 -*-"

# A non persistent model to collect sign-up information
class SignUp
  include  ActiveModel::Model
  extend   ActiveModel::Naming
  attr_accessor :name, :email, :password, :password_confirmation
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation
  def initialize _args={}
    @name = _args.fetch(:name){nil}
    @email = _args.fetch(:email){nil}
    @password = _args.fetch(:password){nil}
    @password_confirmation = _args.fetch(:password_confirmation){nil}
  end
end
