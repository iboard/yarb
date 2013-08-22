# -*- encoding : utf-8 -*-
#
# Object Page acts as an ActiveModel and uses Store for persistence.
class Page

  include Store
  include Store::Timestamps
  key_method :title
  attribute  :title
  attribute  :body
  attribute  :position
  default_order :position, :asc
  attribute  :draft

  def initialize _attributes={}
    set_attributes ensure_defaults(_attributes)
  end

  private
  def ensure_defaults _attributes
    (defaults||={})[:title] ||= ''
    defaults.fetch(:draft) { defaults[:draft] = true }
    defaults.merge!( _attributes )
    defaults
  end

end
