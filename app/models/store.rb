require 'pstore'

# A Wrapper for PStore
module Store

  # @return [String] the path to the data-store for the current environment.
  # @example
  #   .../yarb/db/development
  def self.path
    File.join( Rails.root, 'db', Rails.env )
  end

  # Include ClassMethods to the base-class on include
  def self.included base_class
    base_class.send(:include,ClassMethods)
  end

  # Methods to be included in classes which includes the Store-module
  # @example
  #   class MyClass
  #     include Store
  #   end
  #   object = MyClass.new
  #   object.store_path => .../db/development/my_class/
  module ClassMethods

    # @abstract overwrite this function in your class. 
    # If not overwritten the ruby-object-id will be used.
    # @return [Symbol] the key for this object (record)
    def key
      nil
    end

    # @return [String] the path to the store-files for the class
    def store_path
      File.join( Store::path, self.class.to_s.underscore )
    end

    # @return [Symbol] a unique key for this object
    def store_key
      self.key || self.object_id
    end

    # Write to store-file
    def save
      store.transaction do |s|
        s[self.store_key] = self
      end
    end

    private
    def store
      FileUtils.mkdir_p self.store_path
      PStore.new File.join( store_path, "#{self.class.to_s.underscore}.pstore" )
    end

  end

end
