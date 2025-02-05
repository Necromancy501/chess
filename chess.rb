require_relative 'lib/board'
require_relative 'lib/pieces'
require_relative 'lib/player'
require_relative 'lib/rules'

game = Board.new
charlie = Player.new game, 'white'
carlos = Player.new game, 'black'
charlie.move_piece 'e2', 'e4'
#carlos.move_piece 'd7', 'd5'
#charlie.move_piece 'f1', 'b5' 
#carlos.move_piece 'd8', 'd6'
#charlie.move_piece 'd1', 'g4' 
#carlos.move_piece 'd6', 'e5'
#charlie.move_piece 'e4', 'd5'
puts game