$iterations = 0

class Sudoku
  attr_reader :board
  def initialize(board)
    @board = board.gsub("-","0").split("")
    prepare_row_columns_boxes
    @rows.inspect
    @columns.inspect
    @boxes.inspect
    # puts valid?
    $iterations += 1
  end

  def iterations
    puts "Did #{$iterations} iterations"
    puts
  end

  def solve!
    return false unless valid?
    return @board.join if solved?
    next_empty_index = @board.index("0")
    (1..9).each do |attempt|
      @board[next_empty_index] = attempt
      @solution = Sudoku.new(@board.join).solve!
      return @solution if @solution
    end
    return false
  end

  def valid?
    no_dups?(@rows) && no_dups?(@columns) && no_dups?(@boxes)
  end

  def solved?
    @board.count("0") == 0
  end

  private

  def prepare_row_columns_boxes
    @rows = Array.new(9) {Array.new}
    @columns = Array.new(9) {Array.new}
    @boxes = Array.new(9) {Array.new}
    @board.each_with_index do |value, index|
      next if value == "0"
      @rows[row_for(index)].push value
      @columns[column_for(index)].push value
      @boxes[box_for(index)].push value
    end
  end

  def row_for(index)
    index / 9
  end

  def column_for(index)
    index % 9
  end

  def box_for(index)
    box_column_co = column_for(index) / 3
    row_column_co = row_for(index) / 3
    box_column_co + (row_column_co * 3)
  end

  def no_dups?(set)
    set.each do |subset|
      return false if subset.uniq.length != subset.length
    end
    true
  end
end

