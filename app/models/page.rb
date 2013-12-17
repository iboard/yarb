# -*- encoding : utf-8 -*-
#
# Object Page acts as an ActiveModel and uses Store for persistence.
class Page
  include Store::MongoStore

  field :title
  field :_id, type: String, default: ->{ title }

  validates_presence_of :title
  validates_uniqueness_of :title

  field :body
  field :position, type: Integer, default: 0
  #default_order :position, :asc
  default_scope asc(:position)

  field :draft, type: Boolean, default: true

  def initialize _attributes={}
    super ensure_defaults(_attributes)
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
