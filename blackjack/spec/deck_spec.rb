require 'spec_helper'

describe BlackJack::Deck do

  it "should have 52 cards by default" do
    deck = BlackJack::Deck.new
    expect(deck.cards.count).to eq(52)
  end

  it "should allow variable number of decks" do
    deck = BlackJack::Deck.new(:decks_amount => 2)
    expect(deck.cards.count).to eq(104)
  end

  it "should be possible to take away cards from it" do
    deck = BlackJack::Deck.new
    card = deck.cards.pop
    expect(deck.cards.count).to eq(51)
  end
end
