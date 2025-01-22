require 'rainbow/refinement'
using Rainbow

class Piece_gen

  attr_reader :symbol

  def initialize char, color
    @move_vector = nil
    @symbol = pick_piece char, color
  end

  def pick_piece char, color
    case char
    when 'r'
      color=='black' ? '♜ ' : '♖ '
    when 'b'
      color=='black' ? '♝ ' : '♗ '
    when 'n'
      color=='black' ? '♞ ' : '♘ '
    when 'q'
      color=='black' ? '♛ ' : '♕ '
    when 'k'
      color=='black' ? '♚ ' : '♔ '
    when 'p'
      color=='black' ? '♟ ' : '♙ '
    end
  end

  
end