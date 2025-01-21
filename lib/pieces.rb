require_relative 'piece_gen'

class Pieces

  def initialize kind, color
    @symbol = Piece_gen.new
    @color = color
  end

end