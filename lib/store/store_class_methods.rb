# -*- encoding : utf-8 -*-
module Store

  # ClassMethods for including class
  module ClassMethods

    # Initialize and store new object
    # @param [Array] args - are passed to the initializer of class
    # @return [Object] a new object of class which is saved
    # @raise [DuplicateKeyError] if object with same key exists
    def create! *args
      expire_selector
      new_object = new(*args)
      prevent_duplicate_keys(new_object)
      new_object.save or new_object
    end


    # Initialize and store new object. Doesn't throw an exception but
    # sets object's errors if any.
    # @param [Array] args - are passed to the initializer of class
    # @return [Object] a new object of class.
    def create *args
      expire_selector
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

    # Find an object and update_attributes if found
    # @param [String] id - the key to find
    # @param [Hash] attr - parameters to update
    # @return [Object|false] - see Store::InstanceMethods::save
    def find_and_update_attributes(id, attr)
      object = find(id)
      object.update_attributes( attr ) if object
    end

    # Filter by arguments
    # @param [Hash] args
    # @return [Selector]
    def where *args
      selector.where *args
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
      selector.all #ordered( roots )
    end

    # Sort Ascending
    # @param [Symbol] field - the attribute to sort on
    # @return [Array] of Objects
    def asc field=nil
      selector.asc(field)
      #(field ? sort_ascending(roots, field) : roots).compact
    end

    # Sort Descending
    # @param [Symbol] field - the attribute to sort on
    # @return [Array] of Objects
    def desc field=nil
      selector.desc(field)
      #(field ? sort_descending(roots, field) : roots.reverse).compact
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

    # Attr Accessor
    def default_order_field
      @default_order_field
    end

    # Attr Accessor
    def default_order_direction
      @default_order_direction
    end

    # Define the default order
    def default_order field, direction=:asc
      @default_order_field = field
      @default_order_direction = direction
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
    end

    # Add an attribute and an rw-accessor for it to the class.
    # @param [Symbol] name - the Name of the attribute as symbol
    # @param [Object] attr - type: Integer, default: 0
    def attribute name, *attr

      # Add the attribute
      _attr = AttributeDefinition.new( name, *attr )
      attribute_definitions << _attr

      # Inject object with getter and setter for attribute
      define_setter_and_getter(name, _attr)
    end

    # @return [AttributeDefinitions] the attribute definitions for this class.
    def attribute_definitions
      @attribute_definitions ||= AttributeDefinitions.new
    end

    # @param [String] field the name of the field to get the definition for
    # @return [AttributeDefinition]
    def attribute_definition_of(field)
      @attribute_definitions.find_field(field)
    end

    # @param [Symbol] _attribute - the attribute to search for
    # @param [Object] _value - the value this attribute should have
    # @return [Object|nil]
    def find_by _attribute, _value
      selector.find_by _attribute, _value
      #store.transaction(:read_only) do |s|
        #_key = s.roots.detect { |entry| s[entry].send(_attribute).eql?(_value) }
        #s[_key] if _key
      #end
    end

    # @param [String|Symbol] _key
    # @return [Symbol] - a parameterized symbol of key
    def prepare_key _key
      _key.to_s.parameterize
    end

    # Expires the cache, so next read will reread from file
    def expire_selector
      @selector = nil
    end

    private

    def selector
      @selector ||= Selector.new self, roots
    end

    def roots
      store.transaction(:read_only) { |s| s.roots.map {|r| s[r]} }
    end

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

    def define_setter_and_getter(name, _attr)
      class_eval do

        define_method name do
          _v = instance_variable_get("@#{name.to_s}")
          _v ||= _attr.default if _v.nil?
          _v
        end

        define_method "#{name}=".to_sym do |new_value|
          track_attribute(name, new_value)
          instance_variable_set(
            "@#{name.to_s}", normalize_value("#{name}", new_value)
          )
        end
      end
    end


  end
end
