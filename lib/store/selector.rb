# -*- encoding : utf-8 -*-
module Store

  # This is a draft only and not used by the rest of the application!

  class Selector

    attr_reader :objects

    def initialize klass, objects
      @klass = klass
      @objects = objects
    end

    # Filter by arguments
    # @param [Hash] args 
    # @return [Selector]
    def where *args
      _filter = args.first
      _selection = @objects.select do |s|
        _filter.keys.all? { |k| s.send(k) == _filter.fetch(k) }
      end
      Selector.new @klass, _selection
    end

    # Delegate .map() to the objects array
    def map *args, &block
      @objects.map *args, &block
    end

    # Delegate .each() to the objects array
    # @yield [Object]
    def each *args, &block
      @objects.each *args, &block
    end

    # Count the objects
    # @return [Integer]
    def count
      @objects.count
    end

    # Load all objects in default sort order
    # @return [Array] of all objects in the store
    def all
      ordered @objects
    end

    # The first entry in objects
    # @return [Object]
    def first
      all.first
    end

    # @param [Symbol] _attribute - the attribute to search for
    # @param [Object] _value - the value this attribute should have
    # @return [Object|nil]
    def find_by _attribute, _value
      @objects.detect { |entry| entry.send(_attribute).eql?(_value) }
    end

    # Sort Ascending
    # @param [Symbol] field - the attribute to sort on
    # @return [Array] of Objects
    def asc field=nil
      (field ? sort_ascending(@objects, field) : @objects).compact
    end

    # Sort Descending
    # @param [Symbol] field - the attribute to sort on
    # @return [Array] of Objects
    def desc field=nil
      (field ? sort_descending(@objects, field) : @objects.reverse).compact
    end

    private

    def sort_descending _objects, field
      @objects.sort { |b,a| safe_compare(a,b, field) }
    end

    def sort_ascending _objects, field
      @objects.sort { |a,b| safe_compare(a,b, field) }
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
