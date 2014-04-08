# -*- encoding : utf-8 -*-
#
# Object Page acts as an ActiveModel and uses Store for persistence.
class Page
  include Persistable

  key_method :title
  attribute  :title
  attribute  :body
  attribute  :position, type: Integer, default: 0
  default_order :position, :asc
  attribute  :draft, type: Boolean, default: true

  # Initializer
  # @param [Hash] _attributes attributes Hash
  # @return [Page]
  def initialize _attributes={}
    set_attributes ensure_defaults(_attributes)
  end

  private

  def ensure_defaults _attributes
    defaults = initialize_defaults
    defaults.merge!( _attributes )
    defaults
  end

  def initialize_defaults
    (defaults||={})[:title] ||= ''
    defaults.fetch(:draft) { defaults[:draft] = true }
    defaults
  end

end
