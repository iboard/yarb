# -*- encoding : utf-8 -*-
#
# Thrown when Store tries to save an entry with a violation of a uniqueness field
class UniquenessError < Exception

  attr_reader :object, :field

  # Initializer
  # @param [Object] _object the object
  # @param [String] field field name
  # @return [UniquenessError]
  def initialize _object, field
    @object = _object
    @field  = field
    super "Object #{object.class.to_s}::#{object.key.to_s} should have a unique #{field}"
  end

end
