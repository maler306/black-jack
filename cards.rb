class Cards
  SUITS = %w[+ <3 <> ^].freeze
  HONEURS = %w[J Q K A].freeze
  ACE = /^A/

  attr_accessor :deck

  def initialize
    cards = Hash[(('2'..'10').to_a + HONEURS).zip((2..10).to_a + [10, 10, 10, 11])]
    @deck = []
    SUITS.each do |suit|
      cards.each { |card, value| @deck << { (card + suit) => value } }
    end
    @deck.shuffle!
  end

  def cards_deal
    @deck.pop
  end
end
