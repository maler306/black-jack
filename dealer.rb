class Dealer < Player


  # def initialize(name="Dealer")
  #   @name = name
  #   super
  # end

    def display
    puts "#{@name}"
    @hand.each.with_index(1) { |_card, index| puts "#{index}-я карта - *" }
    end

    def show_cards
      puts "#{@name}:"
      @hand.each.with_index(1) { |(card, value), index| puts "#{index}-я карта - #{card} = #{value}" }
      puts "Количество очков: #{@sum}"
    end

end
