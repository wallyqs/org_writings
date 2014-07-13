require './lib/blackjack.rb'

shared_examples "a blackjack player" do
  it "should identify whether it is busted or not" do
    ten  = BlackJack::Card.new({ :type => 'heart', :value => '10' })
    nine = BlackJack::Card.new({ :type => 'heart', :value => '9' })
    five = BlackJack::Card.new({ :type => 'heart', :value => '5' })

    player = BlackJack::Player.new
    player.hand << ten
    player.hand << nine
    player.hand << five

    expect(player.sum_of_hand).to eq(24)
    expect(player.is_busted?).to eq(true)
  end

  it "should detect when it has a soft hand" do
    ace  = BlackJack::Card.new({ :type => 'heart', :value => 'A' })
    ten = BlackJack::Card.new({ :type => 'heart', :value => '10' })

    player = BlackJack::Player.new
    player.hand << ace
    player.hand << ten

    expect(player.sum_of_hand).to    eq(11)
    expect(player.is_busted?).to     eq(false)
    expect(player.has_soft_hand?).to eq(true)
    expect(player.best_soft_hand_result).to eq(21)
  end
end

module BlackJack
  class Game
    # Should be fast for testing
    def display(chars)
      puts chars
    end

    # Removed exit call
    def game_over
      display ""
      display "********* GAME OVER *********"
      display ""
      exit 0
    end

    def ask_to_continue_game
      game_over if game_cannot_continue
    end
  end
end
