# -*- encoding : utf-8 -*-"

module Store

  # BaseClass for Validators
  class Validator

    attr_reader :object, :field

    # @param [Symbol] field to be validated
    # @param [Object] object to be validated
    def initialize field, object
      @field  = field
      @object = object
    end

    # @abstract Overwrite it in concrete Validator-classes
    # @param [Hash] hash - field: value to be validated
    # @return [Boolean] true
    def validate hash
      true
    end
  end

  # Validate if object with same field and value exits
  class UniqueValidator < Validator

    # Adds Error :already_exists for field.
    # @param [Hash] hash { field: value }
    # @return [Boolean] true if field doesn't have any errors
    def validate hash
      _existing = object.class.find_by( field, hash.fetch(field.to_s))
      unless _existing.nil? || _existing.key == object.key
        object.errors.add(field.to_sym, :already_exists)
      end
      object.errors[field.to_sym].empty?
    end

  end

end
