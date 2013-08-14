# Object Page acts as an ActiveModel and uses Store for persistence.
class Page

  include Store
  key_method :title
  attribute  :title
  attribute  :body

  def initialize _attributes={}
    set_attributes _attributes
  end

end
