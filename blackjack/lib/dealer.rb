module BlackJack
  class Dealer < Player

    def initialize(options={})
      super(options)
      @chips = 0
    end

    def cards_info(options={})
      info = ''

      if options[:reveal_cards]
        return super
      else
        unhidden_cards, hidden_cards = cards.partition.with_index {|_, index| index < 1 }
        unhidden_cards.each do |card|
          info << "- #{card.to_s}\n"
        end
        hidden_cards.each do |card|
          info << "- [?/?]\n"
        end
        info << "\n"
      end

      info
    end
  end
end
