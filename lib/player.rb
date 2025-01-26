class Player

  def initialize board, color
    @board = board
    @color = color
  end

  def move_piece start, finish
    grid = @board.position
    piece_coordinates = self.coordinates_to_indexes start
    end_coordinates = self.coordinates_to_indexes finish

    piece = grid[piece_coordinates[0]][piece_coordinates[1]]
    return if piece == nil || piece.color != @color
    piece_copy = piece.dup

    if valid_move? piece, end_coordinates
      grid[piece_coordinates[0]][piece_coordinates[1]] = nil
      grid[end_coordinates[0]][end_coordinates[1]] = piece_copy
    end

  end

  private

  def coordinates_to_indexes(position)
    # Ensure the input is valid (e.g., a valid chess square)
    return nil unless position.match?(/^[a-h][1-8]$/)
  
    # Convert the letter to a column index (0-based)
    col = position[0].ord - 'a'.ord
    
    # Convert the number to a row index (0-based from the top, so 8 becomes 0)
    row = 8 - position[1].to_i
  
    [row, col]
  end

  def valid_move? piece, finish_coordinates
    moves = piece.figure.symbol
    if moves.kind_of?(Array)
      false
    else
      true
    end
  end

end