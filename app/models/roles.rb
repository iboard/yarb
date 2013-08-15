# Can be used for classes which include Store
# @example
#   class User
#     include Store
#     include Roles
#     key_mehtod :name
#   end
#
#   u=User.new name: 'Fritz The Cat', roles: %w(cat kinky)
#   u.has_role? :kinky #=> true
#   u.has_role? :white #=> false
#   u.roles            #=> [ :cat, :kinky ]
module Roles

  # Default roles
  ROLES = %i(guest confirmed author editor maintainer admin)

  def self.included base
    base.class_eval do
      attribute :roles, [] 
    end
    base.send( :extend,  ClassMethods )
    base.send( :include, InstanceMethods )
  end

  # Defines class-methods for the including class
  module ClassMethods

  end

  # Defines instance methods for objects of classes which includs this module
  module InstanceMethods

    # @param [Symbol|String] role
    # @return [Boolean] true if attribute roles includes role
    def has_role? role
      roles.map(&:to_sym).include?(role.to_sym)
    end
  end

end
