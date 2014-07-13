module BlackJack
  class Player
    attr_accessor :chips
    attr_accessor :hand
    attr_accessor :bet
    alias :cards :hand

    def initialize(options={})
      @chips = options[:chips] || 100
      @hand  = []
    end

    def sum_of_hand
      hand.inject(0) do |total, card|
        total += card.value.to_i
      end
    end

    def is_busted?
      sum_of_hand > 21 ? true : false
    end

    def cards_info(options={})
      info = ''

      cards.each do |card|
        info << "- #{card.to_s}\n"
      end
      info << "\n"

      info
    end

    def has_soft_hand?
      true if cards.any? {|card| card.is_ace? } and (sum_of_hand + 10) <= 21
    end

    def best_soft_hand_result
      possible_results = []

      possible_results << sum_of_hand
      aces_number = cards.select {|c| c.is_ace? }.count

      aces_number.times do |n|
        factor = n + 1
        possible_results << sum_of_hand + factor * 10
      end

      # Get single closest result to 21
      possible_results.select {|result| result <= 21}.max
    end
  end
end
