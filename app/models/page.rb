# Object Page acts as an ActiveModel and uses Store for persistence.
class Page

  include Store
  key_method :title

  attr_accessor :title, :body

  def initialize attributes={}
    @title = attributes.fetch(:title)
    @body =  attributes.fetch(:body) {''}
  end

end
