require 'rainbow/refinement'
using Rainbow

class Board

  attr_accessor :position

  HEIGHT = 8
  WIDTH = 8
  def initialize
    @position = [
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      []
  ]
  @position = self.start_board
  end

  def start_board
    @position.each_with_index do |row, i|
      case i
      when 0..1
        if i == 0
          row.append(Pieces.new 'r', 'black')
          row.append(Pieces.new 'n', 'black')
          row.append(Pieces.new 'b', 'black')
          row.append(Pieces.new 'q', 'black')
          row.append(Pieces.new 'k', 'black')
          row.append(Pieces.new 'b', 'black')
          row.append(Pieces.new 'n', 'black')
          row.append(Pieces.new 'r', 'black')
        elsif i == 1
          8.times do
            row.append(Pieces.new 'p', 'black')
          end
        end
      when 2..5
        8.times do
          row.append nil
        end
      when 6..7
        if i == 7
          row.append(Pieces.new 'r', 'white')
          row.append(Pieces.new 'n', 'white')
          row.append(Pieces.new 'b', 'white')
          row.append(Pieces.new 'q', 'white')
          row.append(Pieces.new 'k', 'white')
          row.append(Pieces.new 'b', 'white')
          row.append(Pieces.new 'n', 'white')
          row.append(Pieces.new 'r', 'white')
        elsif i == 6
          8.times do
            row.append(Pieces.new 'p', 'white')
          end
        end

      end
      
    end
  end

  def to_s
    board_str = ''
    i = 1
    shifter = 1

    @position.each do |row|
      row.each do |elem|

        if i%8 == 1
          board_str += "#{9 - shifter} ".green
        end

        if elem == nil
          if (i+shifter).odd?
            board_str+='□ '
          else
            board_str+='■ '
          end
        else
          board_str+=elem.figure.symbol
        end
        i+=1

        
        
      end
      shifter+=1
      board_str+="\n"
    end
    board_str+="  A B C D E F G H\n".green
    
  end


end