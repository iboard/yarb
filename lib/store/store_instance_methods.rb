# -*- encoding : utf-8 -*-
module Store

  # Methods to be included by objects of the class.
  module InstanceMethods

    # Return the key as param
    # @return [String] key which can be used in hashes and URL-parameters.
    def to_param
      key
    end

    # @return [Hash] the attributes and their values.
    def attributes
      attribute_definitions.get_hashmap_for(self)
    end

    # @return [Array] list of modified attributes
    def modified_attributes
      @modified_attributes ||= []
    end

    # @param [Symbol|String] name of the attributed to be tracked
    def track_attribute name, new_value
      unless self.send(name).eql?(new_value)
        self.modified_attributes << name.to_sym
      end
    end

    # @param [Symbol] _field
    # @return [Object] the default-value for _field
    def default_of _field
      attribute_definitions.default_of _field
    end

    # Update all attributes, listed in Class.attributes.
    # @param [Hash] hash - Attributes to be updated.
    # @return [Boolean] the return-code from save
    # @example
    #   some_object.update_attributes(
    #     name: 'Frank',
    #     dob:  '12/21/1940'
    #   )
    def update_attributes( hash={} )
      set_attributes hash
      valid_without_errors? and save
    end

    # Validate and save object to store-file
    # @return [Boolean] true if no errors and valid
    def save
      if proof_key
        @original_key = self.key
        @new_record = false
        store.transaction() { |s| s[self.key] = self }
        self.send(:after_save)
      end
      self.valid_without_errors? and return self
    end

    # Reload current object
    def reload
      self.class.expire_selector
      self.class.find(self.key)
    end

    # Remove the object from the store
    def delete
      store.transaction() { |s| s.delete(self.key) }
      self.class.expire_selector
    end

    # @return [Boolean] true if object is not saved yet
    def new_record?
      @new_record = true if @new_record.nil?
      @new_record
    end

    # @return [Boolean] true if object is not a new_object
    # Used by Rails form_for / simple_form_for
    def persisted?
      !self.new_record?
    end

    # @see ActiveModel::Conversion
    def to_key
      [self.key]
    end

    # @see ActiveModel::Conversion
    def to_model
      self
    end

    # Restore original-key (called if change-key failed)
    def restore_original_key
      self.send(:"#{self.class.key_method_name}=", @original_key)
    end


    # Temporary saves errors, calls valid? from ActiveModel (which clears errors)
    # and appends previous existing errors again.
    # @return [Boolean] true if no errors
    def valid?
      _errors_before = self.errors.dup
      _s = super
      validate_attributes
      _errors_before.each { |e| append_error(_errors_before,e) }
      self.errors.empty?
    end

    # @return [Boolean] true if no errors and valid?
    def valid_without_errors?
      self.errors.empty? && self.valid?
    end

    private

    def append_error(_errors,field)
      ((self.errors.messages[field]||=[]) << _errors.messages[field]).flatten!
    end

    def validate_attributes
      self.class.validate_object(self)
    end

    def prepare_key _key
      self.class.prepare_key _key
    end

    def attribute_definitions
      self.class.attribute_definitions
    end

    def set_attributes _hash
      hash = HashWithIndifferentAccess.new(_hash)
      attribute_definitions.update(self,hash)
    end

    def proof_key
      (
        self.errors.empty?           &&
        self.valid?                  &&
        self.class.unique_key?(self) &&
        handle_key_changed
      )
    end

    def normalize_value(name,_value)
      _attr = self.class.attribute_definition_of(name.to_sym)
      _attr ? _attr.normalize(_value) : _value
    end

    def handle_key_changed
      return true unless key_changed?
      if self.class.exist?(self.key)
        self.errors.add(:base, format_duplicate_key_error)
        self.restore_original_key
        false
      else
        self.class.delete(@original_key)
        true
      end
    end

    def format_duplicate_key_error
      I18n.t(
        :key_already_exists,
        key_name: self.class.key_method_name,
        value: self.key
      )
    end

    def key_changed?
      @original_key && @original_key != self.key
    end

    def after_load
      @new_record = false
      @modified_attributes = []
    end

    def after_save
      self.class.expire_selector
      @modified_attributes = []
    end

    def store
      self.class.send(:store)
    end

    def store_path
      self.class.send(:store_path)
    end

  end
end
