# -*- encoding : utf-8 -*-"

require "mongoid"

module Store
  module MongoStore

    Mongoid.raise_not_found_error = false

    def self.included base_class
      base_class.send(:extend, ClassMethods)
      base_class.send(:include, Mongoid::Document )
      base_class.send(:include, Mongoid::Timestamps )
    end

    module ClassMethods
      def delete_store!
        self.delete_all
      end

      def expire_selector
        #noop
      end

      # Find an object and update_attributes if found
      # @param [String] id - the key to find
      # @param [Hash] attr - parameters to update
      # @return [Object|false] - see Store::InstanceMethods::save
      def find_and_update_attributes(id, attr)
        object = find(id)
        object.update_attributes( attr ) if object
      end

    end
  end
end
