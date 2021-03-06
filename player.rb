class Player
  attr_accessor :name, :account, :hand, :sum

  def initialize(name = 'Dealer')
    @name = name
    @account = 0
    @sum = 0
    @hand = {}
  end

  def display
    puts "#{@name}, на счету: #{@account}"
    @hand.each.with_index(1) { |(card, value), index| puts "#{index}-я карта - #{card} = #{value}" } # ACE=11
    puts "Количество очков: #{@sum}"
  end

  def count
    @sum = 0
    hand.each_value { |value| @sum += value }
    hand.each do |card|
      @sum -= 10 if @sum > 21 && card[0] =~ Cards::ACE
    end
  end
end
