# -*- encoding : utf-8 -*-
#
# Thrown when Store tries to save an entry with an already existing key
class DuplicateKeyError < Exception

  attr_reader :object

  # Initializer
  # @param [Object] _object the object
  # @return [DuplicateKeyError]
  def initialize _object
    @object = _object
    super "An object of class #{object.class.to_s} with key '#{object.key.to_s}' already exists."
  end

end
