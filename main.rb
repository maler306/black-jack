require_relative 'player'
require_relative 'dealer'
require_relative 'user'
require_relative 'game'
require_relative 'cards'

game = Game.new

loop do
  game.set
end
