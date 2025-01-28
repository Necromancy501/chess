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

    p valid_moves piece, piece_coordinates

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

  def valid_moves piece, start_coordinates, direction = nil, moves_arr = [], i=0, piece_coordinates = nil
    piece_coordinates ||= start_coordinates
    y, x = start_coordinates[0], start_coordinates[1]
    grid = @board.position
    moves = piece.figure.moves
    if moves.kind_of? Array
      direction = moves[i]
      unless direction == nil
        next_move = [y-direction[1], x+direction[0]]
        next_square = (next_move.all? { |value| (0..7).include?(value) }) ? (grid[next_move[0]]&.[](next_move[1])) : nil
        if next_square == nil
          in_bounds = next_move.all? { |value| (0..7).include?(value) }
          if in_bounds
            #return if mate enabler
            moves_arr.append next_move
            valid_moves piece, next_move, direction, moves_arr, i, piece_coordinates
          else
            i+=1
            direction = moves[i]
            valid_moves piece, piece_coordinates, direction, moves_arr, i, piece_coordinates
          end
        else
          i+=1
          direction = moves[i]
          unless next_square.color == @color
            moves_arr.append next_move
          end
          valid_moves piece, piece_coordinates, direction, moves_arr, i, piece_coordinates
        end
      else
        return moves_arr
      end
    else
      vectors = moves[:moves]
      #Rule 1: Orientation
      if moves[:orientation]
        if @color == 'white'
          vectors.pop
        else
          vectors.shift
        end
      end
      vectors.each do |move|
        next_move = [y-move[1], x+move[0]]
        next_square = (next_move.all? { |value| (0..7).include?(value) }) ? (grid[next_move[0]]&.[](next_move[1])) : nil
        if next_square.nil?
          in_bounds = next_move.all? { |value| (0..7).include?(value) }
          if in_bounds
            #return if mate enabler
            moves_arr.append next_move
          end
        else
          if moves[:capture].nil?
            unless next_square.color == @color
              moves_arr.append next_move
            end
          end
        end
      end
      #Rule 1: Captures
      unless moves[:capture].nil?
        captures = moves[:capture]
        captures.each do |move|
          next_move = [y-move[1], x+move[0]]
          next_square = (next_move.all? { |value| (0..7).include?(value) }) ? (grid[next_move[0]]&.[](next_move[1])) : nil
          unless next_square == nil
            unless next_square.color == @color
              moves_arr.append next_move
            end
          end
        end
      end
      #Rule 2: Start Ahead
      if moves[:start_ahead]
        if @color == 'white'
          if y == 6
            next_move = [y-2, x]
            next_square = (next_move.all? { |value| (0..7).include?(value) }) ? (grid[next_move[0]]&.[](next_move[1])) : nil
            if next_square.nil?
              in_bounds = next_move.all? { |value| (0..7).include?(value) }
              if in_bounds
                #return if mate enabler
                moves_arr.append next_move
              end
            end
          end
        else
          if y == 1
            next_move = [y+2, x]
            next_square = (next_move.all? { |value| (0..7).include?(value) }) ? (grid[next_move[0]]&.[](next_move[1])) : nil
            if next_square.nil?
              in_bounds = next_move.all? { |value| (0..7).include?(value) }
              if in_bounds
                #return if mate enabler
                moves_arr.append next_move
              end
            end
          end
        end
      end
      #hash valid moves behavior pending
    end
    moves_arr
  end

  def valid_move? piece, end_coordinates
    moves = piece.figure.symbol
    if moves.kind_of?(Array)
      false
    else
      true
    end
  end

end