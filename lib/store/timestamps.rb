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
            update_timestamps
            super
          end

          private

          def update_timestamps
            ts = Time.now
            self.created_at ||= ts unless modified?(:created_at)
            self.updated_at = ts   unless modified?(:updated_at)
          end

          def modified? _attr
            self.modified_attributes.include?(_attr)
          end

      end

    end

  end

end

