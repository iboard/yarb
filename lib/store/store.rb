# -*- encoding : utf-8 -*-
#
require 'pstore'
require_relative './attribute_definition'
require_relative './attribute_definitions'
require_relative './timestamps'

# A Wrapper for PStore
# @example
#   class MyClass
#     include Store
#     key_method :my_unique_key  # Name this method as you like
#     attribute  :my_unique_key  # adds my_unique_key()
#                                # adds my_uniqeu_key=()
#                                # and supports my_unique_key in update_attributes
#     attribute  :some_field
#
#     def my_unique_key
#       # return a unique key for your object
#     end
#   end
#
#   object = MyClass.new
#   object.update_attributes { some_field: 'Hello worl' }
#   _saved_key = object.key
#   object.save
#   #.... later ....
#   re_read = MyClass.find( _saved_key )
#   # re_read is the same object as before
#   # read from .../db/:env/my_class/my_class.pstore
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

  # ClassMethods for including class
  module ClassMethods
    
    # Initialize and store new object
    # @param [Array] args - are passed to the initializer of class
    # @return [Object] a new object of class which is saved
    # @raise [DuplicateKeyError] if object with same key exists
    def create! *args
      new_object = new(*args)
      prevent_duplicate_keys(new_object)
      new_object.save or new_object
    end


    # Initialize and store new object. Doesn't throw an exception but
    # sets object's errors if any.
    # @param [Array] args - are passed to the initializer of class
    # @return [Object] a new object of class.
    def create *args
      object = create! *args
    rescue DuplicateKeyError => e
      e.object.errors.add :base, e.message
      e.object
    end

    # @return [Boolean] true if key exists
    def exist? _key
      store.transaction(:read_only) do |s| 
        s.roots.any? { |r| r.to_sym == _key.to_sym }
      end
    end

    # Load object from store
    # @param [String|Symbol] _key - the key of the object to find
    # @return [Object|nil]
    def find _key
      _object = store.transaction(:read_only) { |s| s[prepare_key(_key)] }
      _object.send(:after_load) if _object
      _object
    end

    # Delete an entry from store
    # @param [Symbol|string] _key
    # @return [nil|Object] the object removed if there is one.
    def delete _key
      store.transaction() { |s| s.delete(prepare_key(_key)) }
    end

    # List all keys
    # @return [Array] array of object-keys
    def keys
      store.transaction(:read_only) { |s| s.roots }
    end

    # Load all objects
    # @return [Array] of all objects in the store
    def all
      store.transaction(:read_only) { |s| s.roots.map {|r| s[r]} }
    end

    # Define the key-method for this class and add validates_presence_of
    # for the given key.
    # @example
    #   class MyClass
    #     include Store
    #     key_method :uid
    #     def uid
    #       .....
    #     end
    #   end
    # @param [Symbol] method to be called for key()
    def key_method method
      @key_method = method
      validates_presence_of method
      define_method(:key) { prepare_key(self.send method) }
    end

    # @return [Symbol] the key_method for this class
    def key_method_name
      @key_method
    end

    # Deletes the entire store
    def delete_store!
      FileUtils.remove_dir( self.send(:store_path), :force )
    end

    # Delete all entries
    def delete_all!
      store.transaction do |s|
        s.roots.each do |r|
          s.delete r
        end
      end
    end

    # @return [Boolean] true if object's key is unique
    def unique_key? object
      _check = self.find(object.key)
      _unique = !_check || _check != object
      object.errors.add(@key_method, "Key '#{object.key}' already exists.") unless _unique
      _unique
    end

    # Add an attribute and an rw-accessor for it to the class.
    # @param [Symbol] name - the Name of the attribute as symbol
    # @param [Object] default - the default value of the attribute
    def attribute name, default=nil
      attribute_definitions << AttributeDefinition.new( name, default )
      class_eval do
        define_method name do
          instance_variable_get("@#{name.to_s}") || default
        end

        define_method "#{name}=".to_sym do |new_value|
          instance_variable_set "@#{name.to_s}", new_value 
        end
      end
    end

    # @return [AttributeDefinitions] the attribute definitions for this class.
    def attribute_definitions
      @attribute_definitions ||= AttributeDefinitions.new
    end

    # @param [Symbol] _attribute - the attribute to search for
    # @param [Object] _value - the value this attribute should have
    # @return [Object|nil]
    def find_by _attribute, _value
      store.transaction(:read_only) do |s|
        _key = s.roots.detect { |entry| s[entry].send(_attribute).eql?(_value) }
        s[_key] if _key
      end
    end

    # @param [String|Symbol] _key
    # @return [Symbol] - a parameterized symbol of key
    def prepare_key _key
      _key.to_s.parameterize
    end

    private

    def store_path
      File.join( Store::path, self.to_s.underscore )
    end

    def class_file
      "#{self.to_s.underscore}.pstore"
    end

    def store
      FileUtils.mkdir_p store_path unless File.exist?(store_path)
      PStore.new File.join( store_path, class_file )
    end

    def prevent_duplicate_keys(object)
      raise DuplicateKeyError.new( object ) if keys.include?(object.key) 
    end

  end

  # Methods to be included by objects of the class.
  module InstanceMethods

    # Return the key as param
    # @return [String] key which can be used in hashes and URL-parameters.
    def to_param
      key
    end

    # @return [Hash] the attributes and their values.
    def attributes
      attribute_definitions.get_hashmap_for(self)
    end

    # @param [Symbol] _field
    # @return [Object] the default-value for _field
    def default_of _field
      attribute_definitions.default_of _field
    end

    # Update all attributes, listed in Class.attributes.
    # @param [Hash] hash - Attributes to be updated.
    # @return [Boolean] the return-code from save
    # @example
    #   some_object.update_attributes(
    #     name: 'Frank',
    #     dob:  '12/21/1940'
    #   )
    def update_attributes( hash={} )
      set_attributes hash
      self.save 
    end

    # Validate and save object to store-file
    # @return [Boolean] true if no errors and valid
    def save
      if proof_key
        @original_key = self.key
        @new_record = false
        store.transaction() { |s| s[self.key] = self }
      end
      self.valid_without_errors? and return self
    end

    # Remove the object from the store
    def delete
      store.transaction() { |s| s.delete(self.key) }
    end

    # @return [Boolean] true if object is not saved yet
    def new_record?
      @new_record = true if @new_record.nil?
      @new_record
    end

    # @return [Boolean] true if object is not a new_object
    # Used by Rails form_for / simple_form_for
    def persisted?
      !self.new_record?
    end

    # @see ActiveModel::Conversion
    def to_key
      [self.key]
    end

    # @see ActiveModel::Conversion
    def to_model
      self
    end

    # Restore original-key (called if change-key failed)
    def restore_original_key
      self.send(:"#{self.class.key_method_name}=", @original_key)
    end

    # @return [Boolean] true if no errors and valid?
    def valid_without_errors?
      self.errors.empty? && self.valid?
    end

    private

    def prepare_key _key
      self.class.prepare_key _key
    end

    def attribute_definitions
      self.class.attribute_definitions
    end

    def set_attributes _hash
      hash = HashWithIndifferentAccess.new(_hash)
      attribute_definitions.update(self,hash)
    end

    def proof_key
      (
        self.errors.empty?           && 
        self.valid?                  && 
        self.class.unique_key?(self) && 
        handle_key_changed
      )
    end

    def handle_key_changed
      return true unless key_changed? 
      if self.class.exist?(self.key)
        self.errors.add(:base, format_duplicate_key_error)
        self.restore_original_key
        false
      else
        self.class.delete(@original_key)
        true
      end
    end

    def format_duplicate_key_error
      I18n.t(
        :key_already_exists, 
        key_name: self.class.key_method_name, 
        value: self.key
      )
    end

    def key_changed?
      @original_key && @original_key != self.key
    end

    def after_load
      @new_record = false
    end

    def store
      self.class.send(:store)
    end

    def store_path
      self.class.send(:store_path)
    end

  end

end
