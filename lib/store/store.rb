# -*- encoding : utf-8 -*-

require 'pstore'
require_relative './store_class_methods'
require_relative './store_instance_methods'
require_relative './attribute_definition'
require_relative './attribute_definitions'
require_relative './timestamps'
require_relative './boolean'
require_relative './validators'
require_relative './selector'

# A Wrapper for PStore
# @example
#   class MyClass
#     include Store
#     key_method :my_unique_key  # Name this method as you like
#     attribute  :my_unique_key  # adds my_unique_key()
#                                # adds my_unique_key=()
#                                # and supports my_unique_key in update_attributes
#     attribute  :some_field
#     attribute  :another_field, type: Integer, default: 0
#     attribute  :a_flag,        type: Boolean, default: true
#   end
#
#   object = MyClass.new
#   object.update_attributes { my_unique_key: 'first',  some_field: 'Hello worl' }
#   object.save
#   #.... later ....
#   re_read = MyClass.find( 'first' )
#   # reads from .../db/:env/my_class/my_class.pstore
module Store

  # Thrown when an class needs to include Store but didn't
  class NonStoreObjectError < Exception
  end

  # extend the class with ClassMethods and
  # include InstanceMethods to each object of this class
  # Also extends and includes necessary ActiveModel modules
  # Dependencies
  #   ActiveModel::Naming
  #   ActiveModel::Model
  #   ActiveModel::Validations
  def self.included base_class
    base_class.send(:include,  ActiveModel::Model)
    base_class.send(:extend,   ActiveModel::Naming)
    base_class.send(:include,  ActiveModel::Validations)
    base_class.send(:extend,   ClassMethods)
    base_class.send(:include,  InstanceMethods)
  end

  # @return [String] the path to the data-store for the current environment.
  # @example
  #   .../yarb/db/development
  def self.path
    File.join( Rails.root, 'db', Rails.env )
  end

end

