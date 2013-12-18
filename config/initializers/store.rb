# Configure Store

#STORE_GATEWAY=:store
STORE_GATEWAY=:mongoid
autoload :Store, File.expand_path('../../../lib/store/store', __FILE__)


if STORE_GATEWAY == :mongoid
  require_relative "../../lib/store/mongoid.rb"
end
