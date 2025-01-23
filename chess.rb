require_relative 'lib/board'
require_relative 'lib/pieces'
require_relative 'lib/player'

game = Board.new
puts game
charlie = Player.new game, 'white'
carlos = Player.new game, 'black'
charlie.move_piece 'e2', 'e4'
carlos.move_piece 'b8', 'c6'
puts game