# -*- encoding : utf-8 -*-
#
require_relative './store'

module Store

# A Timestore-mixin for Store-objects
# @example
#   class MyClass
#     include Store
#     include Timestamp
#     ....
#   end
#
#   #.... later ....
#   object.createad_at # => Time
#   object.updated_at  # => Time

  module Timestamps

    def self.included base_class
      unless base_class.included_modules.include?(Store)
        raise Store::NonStoreObjectError.new 
      end
      base_class.class_eval do

        attribute :created_at, nil
        attribute :updated_at, nil

          def save
            ts = Time.now
            self.created_at ||= ts
            self.updated_at = ts
            super
          end

      end

    end

  end

end

