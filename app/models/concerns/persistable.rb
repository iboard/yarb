# Combine all includes a persistable module will use
module Persistable
  extend ActiveSupport::Concern

  included do
    case STORE_GATEWAY
    when :store
      include Store
      include Store::Timestamps
    when :mongoid
      include Store::MongoStore
      include Mongoid::Timestamps
    else
      raise StoreGatewayNotDefinedError.new
    end
  end

end
