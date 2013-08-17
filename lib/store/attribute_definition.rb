module Store

  # An AttributeDefinition holds information about a Store-attribute
  # definition, as defined in a Store-class by `attribute :name, 'some default'
  class AttributeDefinition

    attr_reader :name, :default

    def initialize name, default=nil
      @name = name.to_sym
      @default = default
    end

    # @param [Object] object
    # @return [Hash]  { key => value || default }
    def get_hash_for object
      { name => object.send(name) || default }
    end

    # If the attribute is present in _hash_, call the setter for this
    # attribute of object.
    # @param [Object] object
    # @param [Hash] hash
    def update_value_of(object,hash)
      object.send("#{name.to_s}=", hash.fetch(name)) if hash.has_key?(name) 
    end
  end

end
