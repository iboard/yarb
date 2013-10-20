# -*- encoding : utf-8 -*-
#
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
  # Ruby 2.0 only # ROLES = %i(guest confirmed author editor maintainer admin)
  ROLES = [ :guest, :confirmed, :author, :editor, :maintainer, :admin ]

  # Roles necessary to see foreign user's user-information (eg. email)
  SEE_USER_INFORMATION_ROLES = [ :maintainer, :admin ]

  def self.included base
    base.class_eval do
      attribute :roles, type: Array, default: []
      include InstanceMethods
    end
  end

  # Defines instance methods for objects of classes
  # which includes this module.
  module InstanceMethods

    # @param [Symbol|String] role
    # @return [Boolean] true if attribute roles includes role
    def has_role? role
      roles.map(&:to_sym).include?(role.to_sym)
    end

    # @param [Array] roles
    # @return [Boolean] true if any role in roles matches
    def has_any_role? roles
      roles.any? { |r| has_role?(r) }
    end

  end

end
