$LOAD_PATH << File.dirname(__FILE__)
require 'card'
require 'deck'
require 'player'
require 'dealer'

module BlackJack
  class Game
    DEFAULT_CHIPS_MULTIPLIER = 2
    DEFAULT_DECKS_AMOUNT = 1

    attr_accessor :deck
    attr_accessor :player
    attr_accessor :dealer

    def initialize(options={})
      @decks_amount = options[:decks_amount] || DEFAULT_DECKS_AMOUNT
      @chips_bet_multiplier  = options[:chips_bet_multiplier] || DEFAULT_CHIPS_MULTIPLIER
    end


    def play!
      raise "Cannot start playing without a player and a dealer" unless player and dealer
      trap('INT') { game_over }

      display "#########################################"
      display "Welcome to the Blackjack game."
      display ""
      display "Press C-c at any time to exit the game."
      display "#########################################"
      begin
        play_new_hand
      end until game_cannot_continue
      game_over
    end


    def self.start!(options={})
      player = Player.new({:chips => 100 })
      dealer = Dealer.new

      game = Game.new(options)
      game.player = player
      game.dealer = dealer
      game.play!
    end


    def play_new_hand
      deck = Deck.new(:decks_amount => @decks_amount.to_i)
      deck.cards.shuffle!
      player.bet  = 0
      player.hand = []
      dealer.hand = []

      display "Game to be played with #{deck.cards.count} cards."
      display ""
      display "Please make a bet on the number of chips for this round."
      place_bet

      display "#################################"
      display "                                 "
      display " Bet: #{player.bet} chips        "
      display "                                 "
      display "#################################"
      display "                                 "
      display "Game starts!                     "
      display "                                 "


      2.times { dealer.hand << deck.pop }
      display "Dealer cards are:"
      display ""
      display dealer.cards_info


      2.times { player.hand << deck.pop }
      begin
        display "Player cards are:"
        display ""
        display player.cards_info

        next_move = next_move_option
        player.cards << deck.pop if next_move =~ /^h/i
        break if player.is_busted?

        # Then Dealer makes his move
        if dealer.sum_of_hand >= 17
          display "Dealer stands with #{dealer.cards.count} cards. "
        else
          dealer.cards << deck.pop
          display "Dealer hits and now has #{dealer.cards.count} cards. "
        end
        break if dealer.is_busted?
      end until player.sum_of_hand == 21 or next_move =~ /^s/i


      display "Player cards are:"
      display ""
      display player.cards_info

      case
      when player.is_busted?
        display "*** HOUSE WINS: Player's hand (#{player.sum_of_hand}) is over 21. ***"
        process_house_win

      when dealer.is_busted?
        display "*** PLAYER WINS: Dealer's hand (#{dealer.sum_of_hand}) is over 21. ***"
        process_player_win

      when player.sum_of_hand == dealer.sum_of_hand
        display "*** NO WINNER: Tie at #{player.sum_of_hand}, bet needs to be replaced. ***"
        process_tie

      when player.sum_of_hand > dealer.sum_of_hand
        display "*** PLAYER WINS: Dealer's hand (#{dealer.sum_of_hand}) sum is less than the one from the Player (#{player.sum_of_hand}) ***"
        process_player_win

      when player.sum_of_hand < dealer.sum_of_hand
        if player.has_soft_hand?
          best_result = player.best_soft_hand_result
          display "*** Player has a soft hand. Its best result would be: #{best_result} ***"

          case
          when best_result > dealer.sum_of_hand
            display "*** PLAYER WINS: Dealer's hand (#{dealer.sum_of_hand}) sum is less than the one from the Player (#{best_result}) ***"
            process_player_win

          when best_result == dealer.sum_of_hand
            display "*** NO WINNER: Tie at #{best_result}, bet needs to be replaced. ***"
            process_tie

          when best_result < dealer.sum_of_hand
            display "*** HOUSE WINS: Player's hand (#{best_result}) sum is less than the one from the Dealer (#{dealer.sum_of_hand}) ***"
            process_house_win

          else
            raise UnexpectedCondition, "Unexpected winning condition in the game"
          end
        else
          display "HOUSE WINS: Player's hand (#{player.sum_of_hand}) is less than the one from the Dealer (#{dealer.sum_of_hand})"
          process_house_win
        end
      else
        raise UnexpectedCondition, "Unexpected condition in the game"
      end
      ask_to_continue_game
    end

    def next_move_option
      option = ''
      begin
        # The Player makes the first move
        print "Your next move [(h)it | (s)tand]> "
        option = gets
        puts  ""
      end until option =~ /^[hs]/i
      option
    end

    def ask_to_continue_game
      game_over if game_cannot_continue
      display ""
      display "Remaining chips: #{player.chips}"
      print "Play once again? [(y)es | (n)o]> "

      begin
        continue_option = gets
        if continue_option =~ /^y/i
          # pass
        elsif continue_option =~ /^n/i
          game_over
        end
      end until continue_option =~ /^[yn]/i
      display ""
      display "------------------------------------------------------"
    end


    def place_bet
      bet = 0
      begin
        print "How many chips will you bet? [Remaining: #{player.chips}]> "
        bet_amount = gets
        bet = bet_amount.to_i
      end until bet_is_valid?(bet)
      player.bet = bet
    end


    def bet_is_valid?(bet)
      if bet <= 0
        display "INVALID BET: You should at least bet 1 chip."
        return false
      end

      if player.chips < bet
        display "INVALID BET: You don't have enough chips to place that bet."
        return false
      end

      true
    end


    def reveal_dealer_cards
      display "Dealer cards were:"
      display ""
      display dealer.cards_info(:reveal_cards => true)
    end


    def process_player_win
      reveal_dealer_cards
      amount = player.bet * @chips_bet_multiplier
      player.chips += amount
      display "Player wins #{amount} chips."
    end


    def process_house_win
      reveal_dealer_cards
      amount = player.bet
      player.chips -= amount
      display "Player loses #{amount} chips."
    end


    def process_tie
      reveal_dealer_cards
      display "Player keeps bet."
    end


    def game_cannot_continue
      player.chips == 0
    end


    def game_over
      display ""
      display "********* GAME OVER *********"
      display ""
      exit 0
    end


    def display(chars, waiting_time=0.01)
      chars.each_char do |c|
        print c
        sleep waiting_time
      end
      print "\n"
    end

    class UnexpectedCondition < StandardError; end
  end
end
