require_relative 'player'
require_relative 'dealer'
require_relative 'user'
require_relative 'game'
require_relative 'cards'

class Main
  OBJECT_ERROR = 'Ошибка ввода!'.freeze
  MAIN_ACTIONS = { '1' => :add,
                   '2' => :pass,
                   '3' => :open,
                   '4' => :abort }.freeze

  # attr_accessor :game, :user

  def check_in
    puts 'Введите имя'
    name = gets.strip.capitalize!
    @user = User.new(name)
    p @user
  end

  def new_game
    @game=Game.new(@user)
    p @game
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

  def render(method)
    send(method)
    rescue RuntimeError, TypeError => e
    puts e.message
  end

  def show
  [@user, @game.dealer].each { |player| player.display}
  end

  def round
    until @user.hand.size > 2 || (@user.sum || @game.dealer.sum) >=21
    show
    choices
    user_choice = gets.chomp
    self.action(user_choice)
    end
    open
  end

  def new_round
    puts "Новый раунд!"
    @game.first_deal
  end

  def pass
    @game.dealer_choice
  end

  def add
    @game.add_card(@user)
    @user.display
    puts "Ход дилера!"
    sleep 2
    pass
  end

  def open
    @game.open_cards

  end

  def question
    puts "Продолжим?"
    puts "\"Enter\" для продолжения или любой знак для завершения игры!"
    pick = gets.chomp
      if pick == ""
        puts "Продолжаем"
      else
        @user.display
        raise  "Игра завершена"
      end
  end
end

main = Main.new
main.check_in
main.new_game

loop do
  main.set
end
