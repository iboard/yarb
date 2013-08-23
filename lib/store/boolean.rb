# -*- encoding : utf-8 -*-
module Store

  # Ruby has no Boolean class and html-forms will
  # submit "0"/"1" instead of false/true
  # Boolean will handle 0 and 1 and will return
  # a TrueClass or FalseClass
  class Boolean

    # @param [true|false|Integer] value
    # @return [TrueClass|FalseClass]
    # @example
    #   0 => false, 1,2,3... => true
    #   'false', '0', 'no', 'off', '' => false, any other string => true
    def self.new value
      case value
      when String
        _ = value.strip
        ! ['false', '0', 'no', 'off', ''].include?( _ )
      when Integer
        value > 0 
      else
        value
      end
    end
  end
end
