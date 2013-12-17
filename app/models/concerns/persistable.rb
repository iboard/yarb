# Combine all includes a persistable module will use
module Persistable
  extend ActiveSupport::Concern

  included do
    include Store::MongoStore
    include Mongoid::Timestamps
  end

end
