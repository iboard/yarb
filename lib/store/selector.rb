# -*- encoding : utf-8 -*-
module Store


  # Expire caches for given classes
  # @param [Array] classnames
  def self.expire_selectors_for *classnames
    classnames.each { |_model| _model.expire_selector }
  end


  # A Selector is a wrapper for Store-objects.
  # The most important method is where() which returns another Selector,
  # thus one can cascade where() to filter the Store-objects in steps.
  # Use _selection.all() to get the array of selected objects.
  # `count`, `each`, and `map` are delegated to the objects.array
  # `all`, and `to_a` returns the objects-array.
  # @example
  #   admins = User.where(admin: true)
  #   local_admins = admins.where( zip: 4053 )
  #   local_admins.each(&:print)
  class Selector

    attr_reader :objects

    # Initializer
    # @param [Class] klass the class
    # @param [Array[Object]] objects the objects
    # @return [Selector]
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
    # @param [Hash] args arguments to be passed to .map()
    # @param [Object] block block to be passed to .map()
    # @return delegate execution of @object,map
    def map *args, &block
      @objects.map *args, &block
    end

    # Delegate .each() to the objects array
    # @param [Hash] args arguments to be passed to .map()
    # @param [Object] block the block
    # @return delegate execution of @object,map
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

    alias_method :to_a, :all

    # The first entry in objects
    # @return [Object]
    def first
      all.first
    end

    # Fins by attribute/value
    # @param [Symbol] _attribute - the attribute to search for
    # @param [Object] _value - the value this attribute should have
    # @return [Object|nil]
    def find_by _attribute, _value
      @objects.detect { |entry| entry.send(_attribute).eql?(_value) }
    end

    # @param [Object] _id
    # @return [Object|nil] the object found or nil
    def find _id
      @objects.detect { |entry| entry.send(:key).eql?(_id) }
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
      @objects.sort { |b, a| safe_compare(a, b, field) }
    end

    def sort_ascending _objects, field
      @objects.sort { |a, b| safe_compare(a, b, field) }
    end

    def safe_compare a, b, field
      result = a.send(field) <=> b.send(field)
      result ||= a.send(field).to_s <=> b.send(field).to_s
    end

    def ordered _objects
      case @klass.default_order_direction || :none
        when :asc
          sort_ascending(_objects, @klass.default_order_field)
        when :desc
          sort_descending(_objects, @klass.default_order_field)
        else
          _objects
      end
    end

  end

end
