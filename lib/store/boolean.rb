# -*- encoding : utf-8 -*-
module Store

  # Ruby has no Boolean class and html-forms will
  # submit "0"/"1" instead of false/true
  # Boolean will handle 0 and 1 and will return
  # a TrueClass or FalseClass
  class Boolean

    NO_WORDS = %w(false no off disabled 0) + ['']
    # @param [true|false|Integer] value
    # @return [TrueClass|FalseClass]
    # @example
    #   0, -1, -2,... => false, 1,2,3... => true
    #   'false', '0', 'no', 'off', '' => false, any other string => true
    def self.new value
      case value
      when String
        ! NO_WORDS.include?( value.strip )
      when Integer
        value > 0
      else
        value
      end
    end
  end
end
