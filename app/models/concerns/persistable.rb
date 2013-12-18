# Combine all includes a persistable module will use
module Persistable
  extend ActiveSupport::Concern

  included do
    include Store
    include Store::Timestamps
  end

end
