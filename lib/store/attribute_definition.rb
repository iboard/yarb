# -*- encoding : utf-8 -*-
#
module Store

  # An AttributeDefinition holds information about a Store-attribute
  # definition, as defined in a Store-class by `attribute :name, 'some default'
  class AttributeDefinition

    attr_reader :name, :type, :default

    def initialize name, *attr
      @name = name.to_sym
      _attr = attr.first
      @type    = _attr ? _attr.fetch(:type)    { String } : String
      @default = _attr ? initialize_default(@type,_attr.fetch(:default) { nil })    : nil
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

    private

    def initialize_default _type, _value
      _type.new( _value ) if _value
    rescue
      _value
    end

  end

end
