require 'spec_helper'

describe BlackJack::Game do
  it "should have a dealer and a player to play" do
    game   = BlackJack::Game.new
    expect{ game.play! }.to raise_error RuntimeError
  end

  it "should play a random game that exits" do
    expect do
      game   = BlackJack::Game.new
      player = BlackJack::Player.new(:chips => 1)
      dealer = BlackJack::Dealer.new
      game.player = player
      game.dealer = dealer
      game.stub(:gets) { ['1', 'h', 's', 'y'][rand(4)] } # place the bet
      game.play!
    end.to raise_error SystemExit
  end
end
