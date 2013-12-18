
# -*- encoding : utf-8 -*-
#
# Thrown when Store tries to save an entry with an already existing key
class StoreGatewayNotDefinedError < Exception

  def message
    "STORE GATEWAY Not defined! -Please edit config/initializers/store.rb and define either :store or :mongoid as STORE_GATEWAY"
  end

end
