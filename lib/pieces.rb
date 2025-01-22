require_relative 'piece_gen'

class Pieces

  attr_reader :figure

  def initialize kind, color
    @figure = Piece_gen.new kind, color
  end

end