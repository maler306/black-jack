class Game < Player
  BET = 10
  attr_accessor :account, :pot
  attr_reader :user, :dealer, :hand, :cards

  def initialize(user)
    @user=user
    @user.account=100
    @dealer=Dealer.new
    @dealer.account=100
    new_cards
    @pot = 0
  end

  def new_cards
    @cards=Cards.new
  end

  def add_card(player)
    return false if player.hand.size > 2
    cards_off if @cards.deck.size < 2
    player.hand.merge!(cards.cards_deal)
    player.count
  end

  def first_deal
    [@user, @dealer].each do |player|
      player.hand = {}
      self.add_bet(player)
    end
    2.times do
    [@user, @dealer].each { |player| self.add_card(player) }
    end
  end

  def add_bet(player)
    raise "Игра окончена, у #{player.name} закончились деньги" if player.account.zero?
    player.account -= BET
    self.pot += BET
  end

  def win_round(player)
    player.account += @pot
    @pot = 0
    puts "Выиграл #{player.name}"
  end

  def drow
    [@user, @dealer].each { |player| player.account += @pot/2 }
    @pot = 0
    puts "Ничья!"
  end

  def up_cards
    @user.display
    @dealer.show_cards
  end

  def open_cards
    up_cards
    if ((@user.sum > @dealer.sum) && @user.sum < 22) || @dealer.sum > 21
      win_round(@user)
    elsif ((@user.sum < @dealer.sum) && @dealer.sum < 22) || @user.sum > 21
      win_round(@dealer)
    else
      self.drow
    end
    self.clean_hands
  end

  def dealer_choice
    return false if @dealer.hand.count > 2
      if @dealer.sum < 18
        self.add_card(@dealer)
        puts "Дилер: ещё одну карту!"
      else (puts "Дилер: \"пропускаю\"")
      end
  end

  def clean_hands
    [@user, @dealer].each do |player|
      player.hand = {}
    end
  end

  def cards_off
    puts "Колода карт закончилась!"
    puts "Новая колода карт в игре!"
    new_cards
  end

end
