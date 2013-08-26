module Store

  class Selector

    attr_reader :objects

    def initialize klass, objects
      @klass = klass
      @objects = objects
    end

    def to_model
      @klass.to_model
    end

    def all
      ordered( @objects )
    end

    def map *args, &block
      @objects.map(*args, &block)
    end

    def select *args, &block
      @objects.select(*args, &block)
    end

    def asc field=nil
      (field ? @objects.sort_ascending(field) : @objects.all).compact
    end

    def desc field=nil
      (field ? @objects.sort_descending(field) : @objects.all).compact
    end

    private
    def sort_descending _objects, field
      _objects.sort { |b,a| safe_compare(a,b, field) }
    end

    def sort_ascending _objects, field
      _objects.sort { |a,b| safe_compare(a,b, field) }
    end

    def safe_compare a, b, field
      result = a.send(field) <=> b.send(field)
      result ||= a.send(field).to_s <=> b.send(field).to_s
    end


    def ordered _objects
      case @klass.default_order_direction || :none
      when :asc
        sort_ascending(_objects, @klass.default_order_field )
      when :desc
        sort_descending(_objects, @klass.default_order_field )
      else
        _objects
      end
    end

  end

end
