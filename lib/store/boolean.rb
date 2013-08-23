# -*- encoding : utf-8 -*-
module Store

  # Ruby has no Boolean class and html-forms will
  # submit "0"/"1" instead of false/true
  # Boolean will handle 0 and 1 and will return
  # a TrueClass or FalseClass
  class Boolean

    # @param [true|false|Integer] value
    # @return [TrueClass|FalseClass] "1", 1, true will return true
    def self.new value
      case value
      when String
        value == '1' 
      when Integer
        value == 1 
      else
        value
      end
    end
  end
end
