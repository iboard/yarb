require 'pstore'

# A Wrapper for PStore
# @example
#   class MyClass
#     include Store
#     key_method :my_unique_key  # Name this method as you like
#
#     def my_unique_key
#       # return a unique key for your object
#     end
#   end
#
#   object = MyClass.new
#   _saved_key = object.key
#   object.save
#   #.... later ....
#   re_read = MyClass.find( _saved_key )
#   # re_read is the same object as before
#   # read from .../db/:env/my_class/my_class.pstore
module Store

  # extend the class with ClassMethods and
  # include InstanceMethods to each object of this class
  # Also extends and includes necessary ActiveModel modules
  # Dependencies
  #   ActiveModel::Naming
  #   ActiveModel::Model
  #   ActiveModel::Validations
  def self.included base_class
    base_class.send(:extend,   ActiveModel::Naming)
    base_class.send(:include,  ActiveModel::Model)
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
      new_object.save
      new_object
    end


    # Initialize and store new object. Doesn't throw an exception but
    # sets object's errors if any.
    # @param [Array] args - are passed to the initializer of class
    # @return [Object] a new object of class.
    def create *args
      create! *args
    rescue DuplicateKeyError => e
      e.object.errors.add :base, e.message
      e.object
    end

    # Load object from store
    # @param [String|Symbol] _key - the key of the object to find
    # @return [Object|nil]
    def find _key
      store.transaction(:read_only) { |s| s[_key.parameterize] }
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
      self.send :validates_presence_of, method
      define_method(:key) { (self.send method).parameterize }
    end

    # List all keys
    # @return [Array] array of object-keys
    def keys
      store.transaction(:read_only) { |s| s.roots }
    end

    # Deletes the entire store
    def delete_store!
      FileUtils.remove_dir( self.send(:store_path), :force )
    end

    # @return [Boolean] true if object's key is unique
    def unique_key? object
      _check = self.find(object.key)
      _unique = !_check || _check != object
      object.errors.add(@key_method, "Key '#{object.key}' already exists.") unless _unique
      _unique
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
      raise DuplicateKeyError.new( object ) if keys.include?(object.key.parameterize) 
    end
  end

  # Methods to be included by objects of the class
  module InstanceMethods

    # Return the key as param
    # @return [String] key which can be used in hashes and URL-parameters
    def to_param
      key.parameterize
    end

    # Validate and save object to store-file
    # @return [Store] self
    def save
      if self.valid? && self.class.unique_key?(self)
        store.transaction() { |s| s[self.key] = self }
      end
      self
    end

    # Remove the object from the store
    def delete
      store.transaction() { |s| s.delete(self.key) }
    end

    private

    def store
      self.class.send(:store)
    end

    def store_path
      self.class.send(:store_path)
    end

  end

end
