$LOAD_PATH << File.dirname(__FILE__)
require 'spec_helper'

describe BlackJack::Dealer do
  it_behaves_like "a blackjack player"

  it "should not have chips at the beginning by default" do
    dealer = BlackJack::Dealer.new
    expect(dealer.chips).to eq(0)
  end

  it "should not reveal its card info" do
    ten  = BlackJack::Card.new({ :type => 'heart', :value => '10' })
    ace  = BlackJack::Card.new({ :type => 'heart', :value => 'A' })

    dealer = BlackJack::Dealer.new
    dealer.hand << ten
    dealer.hand << ace

    expected_string = ""
    expected_string << "- [10/heart]\n"
    expected_string << "- [?/?]\n\n"
    expect(dealer.cards_info).to eq(expected_string)
  end
end
