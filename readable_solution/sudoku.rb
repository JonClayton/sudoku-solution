class Cell
  attr_accessor :index, :value, :row, :col, :box

  def initialize(array)
    @index = array[0]
    @row = $row_for_cell[index]
    @col = $col_for_cell[index]
    @box = $box_for_cell[index]
    @value = array[1]
  end

end

# each "test" for a solved board has an array of the nine index numbers for the cells in that test
$rows = (0..80).each_slice(9).to_a
$cols = (0..80).to_a.map{|x| x%9*9+x/9}.each_slice(9).to_a
$boxes = (0..80).to_a.map{|x| x%3+x%9/3*9+x/9*3+x/27*18}.each_slice(9).to_a

# each cell has a row, column and box that it is a member of
$row_for_cell = (0..80).to_a.map{|x| x/9}
$col_for_cell = (0..80).to_a.map{|x| x%9}
$box_for_cell = (0..80).to_a.map{|x| x/27*3+x%9/3}

class Sudoku

attr_accessor :board_array

  def initialize(board_string)
    setup_board_array(board_string)
  end

  def board_as_string
    board_array.map {|cell| cell.value}.join('')
  end

  def to_s # so "puts board" works nicely -- required method
    board_as_string.scan(/.{9}/).join("\n")
  end

  def solve
    @cell_to_guess_next = blank_cell_with_least_alternatives
    return if game_is_unsolvable
    values_available_for(cell_to_guess_next).each do |guess|
      @next_game = Sudoku.new(board_including(guess))
      next_game.solve
      declare_victory and return if next_game.board_complete?
    end
  end

  def board_complete?
    board_array.all?{|cell| cell.value != '-'}
  end

private

attr_accessor :cell_to_guess_next, :next_game
    
  def setup_board_array(board_string)
    @board_array = (0..80).to_a.zip(board_string.split('')).map{|x| Cell.new(x)}
  end

  def blank_cell_with_least_alternatives
    board_array.min_by{|cell| (cell.value == '-') ? values_available_for(cell).size : 10}
  end

  def values_available_for(cell)
    ('1'..'9').to_a - values_already_in($rows[cell.row]) - values_already_in($cols[cell.col]) - values_already_in($boxes[cell.box])
  end

  def values_already_in(test)
    test.map {|cell| board_array[cell].value}
  end

  def game_is_unsolvable
    values_available_for(cell_to_guess_next).size == 0
  end

  def declare_victory
    @board_array = next_game.board_array
  end

  def board_including(guess)
    string = board_as_string
    string[cell_to_guess_next.index] = guess
    string
  end

end
