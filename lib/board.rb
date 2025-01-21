require 'rainbow/refinement'
using Rainbow

class Board

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
  end

  def to_s
    board_str = ''
    i = 1
    shifter = 1

    HEIGHT.times do
      WIDTH.times do

        if i%8 == 1
          board_str += "#{9 - shifter} ".green
        end


        if (i+shifter).odd?
          board_str+='□ '
        else
          board_str+='■ '
        end
        i+=1

      end
      shifter+=1
      board_str+="\n"
    end
    board_str+="  A B C D E F G H\n".green
  end


end