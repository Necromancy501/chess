require_relative 'piece_gen'

class Pieces

  attr_reader :figure, :color

  def initialize kind, color
    @figure = Piece_gen.new kind, color
    @color = color
  end

end