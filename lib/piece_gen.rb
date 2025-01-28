require 'rainbow/refinement'
using Rainbow

class Piece_gen

  attr_reader :symbol, :moves

  def initialize char, color;
    @moves = pick_moves char
    @symbol = pick_piece char, color
  end

  def pick_piece(char, color)
    case char
    when 'r'
      color == 'black' ? '♖ ' : '♜ '
    when 'b'
      color == 'black' ? '♗ ' : '♝ '
    when 'n'
      color == 'black' ? '♘ ' : '♞ '
    when 'q'
      color == 'black' ? '♕ ' : '♛ '
    when 'k'
      color == 'black' ? '♔ ' : '♚ '
    when 'p'
      color == 'black' ? '♙ ' : '♟ '
    end
  end

  def pick_moves char
    #Arrays for recursive pieces, hashes for non-recursives.
    case char
    when 'r'
      [[1,0],[0,1],[-1,0],[0,-1]]
    when 'b'
      [[1,1],[-1,-1],[1,-1],[-1,1]]
    when 'n'
      {
        moves: [[1,2],[-1,2],[1,-2],[-1,-2],[2,1],[-2,1],[2,-1],[-2,-1]],
        orientation: false,
        capture: nil,
        start_ahead: false,
        castle: false,
      }
    when 'q'
      [[1,0],[0,1],[-1,0],[0,-1],[1,1],[-1,-1],[1,-1],[-1,1]]
    when 'k'
      {
        moves: [[1,0],[0,1],[-1,0],[0,-1],[1,1],[-1,-1],[1,-1],[-1,1]],
        orientation: false,
        capture: nil,
        start_ahead: false,
        castle: true,
      }
    when 'p'
      {
        orientation: true,
        moves: [[0,1],[0,-1]],
        capture: [[1,1],[-1,1]],
        start_ahead: true,
        castle: false,
      }
    end
    
  end
  

  
end