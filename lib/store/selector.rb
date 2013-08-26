module Store

  # This is a draft only and not used by the rest of the application!

  class Selector

    attr_reader :objects

    def initialize klass, objects
      @klass = klass
      @objects = objects
    end

    def all
      @objects
    end

    def method_missing method, *args, &block
      @klass.send method, args, block
    end

  end

end
