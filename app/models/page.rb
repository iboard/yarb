# -*- encoding : utf-8 -*-
#
# Object Page acts as an ActiveModel and uses Store for persistence.
class Page

  include Store
  include Store::Timestamps
  key_method :title
  attribute  :title
  attribute  :body

  def initialize _attributes={}
    set_attributes ensure_defaults(_attributes)
  end

  private
  def ensure_defaults _attributes
    (defaults||={})[:title] = ''
    defaults.merge( _attributes )
  end

end
