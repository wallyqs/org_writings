require 'card'
module BlackJack
  class Deck
    attr_reader :cards

    CARD_TYPES  = %w(♤ ♦ ♥ ♣)
    CARD_VALUES = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

    def initialize(options={})
      @cards = []

      number_of_decks = options[:decks_amount] || 1
      number_of_decks.times do
        deck_of_cards = CARD_TYPES.map do |t|
          CARD_VALUES.map do |v|
            Card.new({ :type => t, :value => v })
          end
        end
        @cards << deck_of_cards
      end

      @cards.flatten!
    end

    def pop
      @cards.pop
    end
  end
end
