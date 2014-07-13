require 'spec_helper'

describe BlackJack::Player do
  it_behaves_like "a blackjack player"

  it "should have 100 chips at the beginning by default" do
    player = BlackJack::Player.new
    expect(player.chips).to eq(100)
  end

  it "should show its card info" do
    ten  = BlackJack::Card.new({ :type => 'heart', :value => '10' })

    player = BlackJack::Player.new
    player.hand << ten

    expected_string = "- [10/heart]\n\n"
    expect(player.cards_info).to eq(expected_string)
  end
end
