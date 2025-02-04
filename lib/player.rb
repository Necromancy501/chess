class Player

  attr_accessor :starts_used, :king_pos

  def initialize board, color
    @board = board
    @color = color
    @starts_used = Set.new
    @king_pos = color == 'white' ? [7,4] : [0,4]
  end

  def move_piece start, finish

    grid = @board.position
    piece_coordinates = self.coordinates_to_indexes start
    end_coordinates = self.coordinates_to_indexes finish

    piece = grid[piece_coordinates[0]][piece_coordinates[1]]
    return if piece == nil || piece.color != @color
    piece_copy = piece.dup

    if valid_move? piece, piece_coordinates, end_coordinates
      grid[piece_coordinates[0]][piece_coordinates[1]] = nil
      grid[end_coordinates[0]][end_coordinates[1]] = piece_copy
      @starts_used.add piece_coordinates
      @king_pos = end_coordinates if piece.figure.name == 'King'
    end

  end

  def checked?
    all_moves_opposite.include? @king_pos
  end

  private

  def enables_check? piece_coordinates, end_coordinates
    board_copy = @board.dup
    player_obj = Player.new board_copy, @color
    grid = board_copy.position

    piece = grid[piece_coordinates[0]][piece_coordinates[1]]
    piece_copy = piece.dup

    grid[piece_coordinates[0]][piece_coordinates[1]] = nil
    grid[end_coordinates[0]][end_coordinates[1]] = piece_copy
    player_obj.starts_used.add piece_coordinates
    player_obj.king_pos = end_coordinates if piece.figure.name == 'King'

    player_obj.checked?
  end

  def all_moves_opposite
    grid = @board.position
    y = 0
    grid.reduce(Set.new) do |moves, row|
      row.each_with_index do |piece, x|
        unless piece.nil?
          unless piece.color == @color
            piece_moves = valid_moves(piece, [y,x])
            piece_moves.each do |move|
              moves.add move
            end
          end
        end
      end
      y += 1
      moves
    end
  end

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
      #Rule 2: Captures
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
      #Rule 3: Start Ahead
      if moves[:start_ahead]
        if @color == 'white'
          if y == 6
               #castle pending
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

      if moves[:castle]
        if @color == 'white'
          unless @starts_used.include? [7,4]
            if grid[7][5].nil? && grid[7][6].nil?
              unless all_moves_opposite.include?([7,5]) || all_moves_opposite.include?([7,6])
                moves_arr.append [7,6]
              end
            elsif grid[7][1].nil? && grid[7][2].nil? && grid[7][3].nil?
              unless all_moves_opposite.include?([7,1]) || all_moves_opposite.include?([7,2]) || all_moves_opposite.include?([7,3])
                moves_arr.append [7,2]
              end
            end
          end
        else
          unless @starts_used.include? [0,4]
            if grid[0][5].nil? && grid[0][6].nil?
              unless all_moves_opposite.include?([0,5]) || all_moves_opposite.include?([0,6])
                moves_arr.append [0,6]
              end
            elsif grid[0][1].nil? && grid[0][2].nil? && grid[0][3].nil?
              unless all_moves_opposite.include?([0,1]) || all_moves_opposite.include?([0,2]) || all_moves_opposite.include?([0,3])
                moves_arr.append [0,2]
              end
            end
          end
        end
      end
    end
    moves_arr
  end

  def valid_move? piece, piece_coordinates, end_coordinates
    unless enables_check? piece_coordinates, end_coordinates
      valid_moves(piece, piece_coordinates).include? end_coordinates
    end
  end

end