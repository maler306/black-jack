class Game < Player
  OBJECT_ERROR = 'Ошибка ввода!'.freeze
  MAIN_ACTIONS = { '1' => :add_to_user, '2' => :dealer_choice, '3' => :open_cards, '4' => :abort }.freeze
  BET = 10
  attr_accessor :account, :pot
  attr_reader :user, :dealer, :hand, :cards

  def initialize
    @user = check_in
    @user.account = 100
    @dealer = Dealer.new
    @dealer.account = 100
    new_cards
    @pot = 0
  end

  def set
    new_round
    round
    question
  end

  def choices
    puts 'Выберите действие'
    puts '1-- добавить карту.'
    puts '2-- пропустить ход'
    puts '3-- открыть карты'
    puts '4-- выход'
  end

  def action(user_choice)
    act = MAIN_ACTIONS.fetch(user_choice) { puts 'Некорректный ввод, выберите от 1 до 4' }
    render(act)
  end

  private

  def new_cards
    @cards = Cards.new
  end

  def add_card(player)
    return false if player.hand.size > 2
    cards_off if @cards.deck.size < 2
    player.hand.merge!(cards.cards_deal)
    player.count
    open_cards if (@user.hand.size && @dealer.hand.size == 3) || player.sum > 21
  end

  def add_to_user
    add_card(@user)
    @user.display
    puts 'Ход дилера!'
    sleep 3
    dealer_choice
  end

  def first_deal
    [@user, @dealer].each do |player|
      player.hand = {}
      add_bet(player)
    end
    2.times do
      [@user, @dealer].each { |player| add_card(player) }
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
    [@user, @dealer].each { |player| player.account += @pot / 2 }
    @pot = 0
    puts 'Ничья!'
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
      drow
    end
    clean_hands
    question
    new_round
  end

  def dealer_choice
    return false if @dealer.hand.count > 2
    if @dealer.sum < 18
      add_card(@dealer)
      puts 'Дилер: ещё одну карту!'
    else (puts 'Дилер: "пропускаю"')
    end
  end

  def clean_hands
    [@user, @dealer].each do |player|
      player.hand = {}
    end
  end

  def cards_off
    puts 'Колода карт закончилась!'
    puts 'Новая колода карт в игре!'
    new_cards
  end

  def check_in
    puts 'Введите имя'
    name = gets.strip.capitalize
    @user = User.new(name)
  end

  def render(method)
    send(method)
  rescue RuntimeError, TypeError => e
    puts e.message
  end

  def show
    [@user, @dealer].each(&:display)
  end

  def round
    until @user.hand.size > 2 || (@user.sum || @dealer.sum) >= 21
      show
      choices
      user_choice = gets.chomp
      action(user_choice)
    end
    open_cards
  end

  def new_round
    puts 'Новый раунд!'
    first_deal
  end

  def question
    puts 'Продолжим?'
    puts '"Enter" для продолжения или любой знак для завершения игры!'
    pick = gets.chomp
    if pick == ''
      puts 'Продолжаем'
    else
      @user.display
      raise 'Игра завершена'
    end
  end
end
