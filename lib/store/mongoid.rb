# -*- encoding : utf-8 -*-"

require "mongoid"

module Store
  module MongoStore

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
    end
  end
end
