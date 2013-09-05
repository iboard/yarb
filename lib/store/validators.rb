# -*- encoding : utf-8 -*-"

module Store

  class Validator
    attr_reader :object, :field

    def initialize field, object
      @field  = field
      @object = object
    end

    def validate hash
      true
    end
  end

  class UniqueValidator < Validator
    def validate hash
      _existing = object.class.find_by( field, hash.fetch(field.to_s))
      _valid = _existing.nil? || _existing.key == object.key
      unless _valid
        object.errors.add(field.to_sym, :already_exists)
      end
      object.errors[field.to_sym].nil?
    end
  end

end
