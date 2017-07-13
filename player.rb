class Player
  attr_accessor :name, :account, :hand, :sum

  def initialize(name="Dealer")
    @name = name
    @account = 0
    @sum = 0
    @hand = {}
  end

  def display
    puts "#{@name}, на счету: #{@account}"
    @hand.each.with_index(1) { |(card, value), index| puts "#{index}-я карта - #{card} = #{value}" }#ACE=11
    puts "Количество очков: #{@sum}"
  end

  def count
    @sum = 0
    self.hand.each_value{|value| @sum+= value}
    self.hand.each do |card|
      if @sum > 21 && card[0] =~ Cards::ACE
        @sum -= 10
      end
    end
  end

end
