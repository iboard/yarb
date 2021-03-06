# -*- encoding : utf-8 -*-
#
module Store

  # Validators exists for ... as UniqueValidator, EMailValidator, ...
  REGISTERED_VALIDATIONS = [:unique,:email]

  # An AttributeDefinition holds information about a Store-attribute
  # definition, as defined in a Store-class by
  # `attribute :name, default: 'some default', type: AnyClass
  class AttributeDefinition

    attr_reader :name, :type, :default, :validations

    # Initializer
    # @param [String] name name
    # @param [Hash] attr attribute Hash
    # @return [AttributeDefinition]
    def initialize name, *attr
      @name = name.to_sym
      _attr = attr.first
      @type    = get_type_from _attr
      @default = get_default_from _attr
      @validations = get_validations_from _attr
    end

    # @param [Object] _value
    # @return [Object] with proper datatype
    def normalize _value
      initialize_default(@type, _value)
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
      if validate_update(object, hash)
        object.send("#{name.to_s}=",
                    normalize(hash.fetch(name))
                   ) if hash.has_key?(name)
      end
    end


    # Validate all fields of object for which a validation exists
    # Adds errors to object.errors if detected.
    # @param [Object] object the object to be validated
    def validate_object object
      validations.each do |validation|
        validator = validator_for(validation, object)
        validator.validate( name.to_s => object.send(name) )
      end
    end

    # Checks for existence of uniqueness validator
    # @return [Boolean] true if one of the validators is an uniqueness-validator.
    def has_uniqueness_validator?
      validations.any? { |v| v[0] == :unique }
    end

    private

    def validate_update(object,hash)
      return true unless has_validations?
      @validations.all? do |validation|
        validator = validator_for( validation, object )
        validator.validate(hash)
      end
    end

    def validator_for validation, object
      eval("Store::#{validation[0].to_s.camelcase}Validator").new( name, object )
    end

    def has_validations?
      !@validations.empty?
    end

    def get_validations_from _attr
      return [] unless _attr
      _attr.select { |key, _value| REGISTERED_VALIDATIONS.include?(key) }
    end

    def get_default_from _attr
      _attr ? initialize_default(@type,_attr.fetch(:default){nil}) : nil
    end

    def get_type_from(_attr)
      _attr ? _attr.fetch(:type){ String } : String
    end

    def initialize_default _type, _value
      _type.new( _value )
    rescue
      _value
    end

  end

end
