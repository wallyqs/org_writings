require 'spec_helper'

describe BlackJack::Card do

  it "should have a valid numerical value" do
    invalid_values = %w(1 0 1000 B AA -1)
    invalid_values.each do |v|
      expect do
        BlackJack::Card.new({ :type => 'heart', :value => v })
      end.to raise_error ArgumentError
    end
  end

  it "should allow numerical values defined by the deck" do
    BlackJack::Deck::CARD_VALUES.each do |v|
      expect do
        BlackJack::Card.new({ :type => 'club', :value => v })
      end.not_to raise_error
    end
  end

  it "should identify aces" do
    c = BlackJack::Card.new({ :type => 'club', :value => 'A' })
    expect(c.is_ace?).to be true
  end

  it "should pretty print the value" do
    c = BlackJack::Card.new({ :type => '<>', :value => '5' })
    expect(c.to_s).to eq "[5/<>]"
  end
end
