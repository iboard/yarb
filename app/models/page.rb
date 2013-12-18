# -*- encoding : utf-8 -*-
#
# Object Page acts as an ActiveModel and uses Store for persistence.

class Page
  include Persistable

  case STORE_GATEWAY
  when :mongoid
    field :title
    field :_id, type: String, default: ->{ to_param }

    validates_presence_of :title
    validates_uniqueness_of :title

    field :body
    field :position, type: Integer, default: 0

    default_scope asc(:position)

    field :draft, type: Boolean, default: true

    def initialize _attributes={}
      super ensure_defaults(_attributes)
    end

    def after_save
      #noop
    end

    def to_param
      permalink(self.title)
    end
  when :store
    key_method :title
    key_method :title
    attribute  :title
    attribute  :body
    attribute  :position, type: Integer, default: 0
    default_order :position, :asc
    attribute  :draft, type: Boolean, default: true

    def initialize _attributes={}
      set_attributes ensure_defaults(_attributes)
    end
  else
    raise StoreGatewayNotDefinedError.new
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

  def permalink str
    str.gsub(/\s+/, "-").downcase
  end

end
