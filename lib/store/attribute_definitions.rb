# -*- encoding : utf-8 -*-
#
module Store

  # A List of AttributeDefiniton-object
  class AttributeDefinitions

    attr_reader :attribute_definitions

    # @param [Array|nil] definitions - pre-defined attribute-definitions
    def initialize definitions=[]
      @attribute_definitions = definitions
    end

    delegate :each, to: :attribute_definitions

    # Add a new AttributeDefinition to the list
    # @param [AttributeDefiniton] new_attribute - the definition to add.
    def <<(new_attribute)
      @attribute_definitions << new_attribute
    end

    # Build an Array with hash-pairs for each attribute of object
    # @param [Object] object - the object to fetch the values from
    # @return [Array] of { key: 'value' }, { other_key: 'other_value' }, ...
    def get_hashmap_for object
      @attribute_definitions.map { |_attr| _attr.get_hash_for(object) }
    end

    # @param [Symbol] _field
    # @return [Object|nil] the default value for _field.
    def default_of _field
      (_a = find_field _field) and _a.default
    end

    # @param [String|Symbol] _field
    # @return [AttributeDefinition] for this field
    def find_field(_field)
      @attribute_definitions.detect{ |_attr| _attr.name == _field }
    end

    # Update all attributes of object with values from hash.
    # Attributes not included in hash will be ignored.
    # @param [Object] object - the object to be updated.
    # @param [Hash] hash - params as in Rails params[:object]
    # @return [Object] - the updated object.
    def update object, hash
      @attribute_definitions.each do |_attribute|
        _attribute.update_value_of(object,hash)
      end
      object
    end

    # Validate all attributes of object and add errors if detected.
    # @param [Object] object
    def validate_object object
      @attribute_definitions.each do |attr|
        attr.validate_object object
      end

    end
  end
end
