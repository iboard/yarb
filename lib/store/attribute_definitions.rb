module Store

  # A List of AttributeDefiniton-object
  class AttributeDefinitions

    # @param [Array|nil] definitions - pre-defined attribute-definitions
    def initialize definitions=[]
      @attribute_definitions = definitions
    end

    # Add a new AttributeDefinition to the list
    # @param [AttributeDefiniton] other - the definition to add.
    def <<(other)
      @attribute_definitions << other
    end
    
    # Build an Array with hash-pairs for each attribute of object
    # @param [Object] object - the object to fetch the values from
    # @return [Array] of { key: 'value' }, { other_key: 'other_value' }, ...
    def get_hashmap_for object
      @attribute_definitions.map do |_attribute|
        _attribute.get_hash_for(object)
      end
    end

    # @param [Symbol] _field
    # @return [Object|nil] the default value for _field.
    def default_of _field
      _a = @attribute_definitions.detect{|_attr| _attr.name == _field}
      _a.default if _a
    end

    # Update all attributes of object with values from hash
    # @param [Object] object - the object to be updated
    # @param [Hash] hash - params as in Rails params[:object]
    # @return [Object] - the updated object
    def update object, hash
      @attribute_definitions.each do |_attribute|
        _attribute.update_value_of(object,hash)
      end
      object
    end
  end
end