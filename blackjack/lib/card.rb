module BlackJack
  class Card
    attr_reader :type
    attr_reader :value

    def initialize(options)
      @type  = options[:type]
      @value = Value.new(options[:value])
    end

    def is_ace?
      @value.label == 'A'
    end

    def to_s
      "[#{value}/#{type}]"
    end

    class Value
      attr_reader :label

      def initialize(label)
        @label = label
        self.to_i
      end

      def to_s
        @label
      end

      def to_i
        case @label
        when 'J', 'Q', 'K'
          10
        when 'A'
          1
        when '2', '3', '4', '5', '6', '7', '8', '9', '10'
          @label.to_i
        else
          raise ArgumentError, "Invalid value '#{@label}' given to a card!"
        end
      end
    end
  end
end
