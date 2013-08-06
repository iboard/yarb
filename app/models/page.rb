# Object Page acts as an ActiveModel and uses Store for persistence.
class Page
  include ActiveModel::Model
  include ActiveModel::Validations

  include Store
  key_method :to_param

  attr_accessor :title, :body
  validates_presence_of :title

  def initialize attributes={}
    @title = attributes.fetch(:title)
    @body =  attributes.fetch(:body) {''}
    @param=  to_param(title)
  end

  # Returns the title of the page formated as parameter.
  #  The initializer calls this method with the given title.
  #  The method sets the instance-variable @param
  # @example
  #   to_param('Page Title') => 'page_title'
  #   to_param               => 'page_title'
  # @param [String] _title - optional, if given this title is used
  # @return [String] underscored title
  def to_param _title=nil
    return @param unless _title
    @param = _title.parameterize
  end
end
