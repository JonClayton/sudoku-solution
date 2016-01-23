# each "test" for a solved board has an array of the nine index numbers for the cells in that test
$rows = (0..80).each_slice(9).to_a
$cols = (0..80).to_a.map{|x| x%9*9+x/9}.each_slice(9).to_a
$boxes = (0..80).to_a.map{|x| x%3+x%9/3*9+x/9*3+x/27*18}.each_slice(9).to_a

# each cell has a row, column and box that it is a member of
$row_of_cell = (0..80).to_a.map{|x| x/9}
$col_of_cell = (0..80).to_a.map{|x| x%9}
$box_of_cell = (0..80).to_a.map{|x| x/27*3+x%9/3}

class Sudoku

  attr_accessor :board

  def initialize(board)
    @board = board
    @no_new_solutions = false
  end

  def to_s # so "puts game" works nicely in runner -- required method
    board.scan(/.{9}/).join("\n")
  end

  def solve
    run_solver until @no_new_solutions
    return if board_complete? || !@best_guess
    start_guessing
  end

  def board_complete?
    !board.include?('-')
  end

  private

  def run_solver
    @no_new_solutions = true
    return unless grid_is_valid_when_checking_rows_cols_and_boxes
    @best_guess = result_of_inspecting_all_cells_for_quick_wins
  end

  def grid_is_valid_when_checking_rows_cols_and_boxes
    return false unless @available_nums_for_row = test($rows)
    return false unless @available_nums_for_col = test($cols)
    return false unless @available_nums_for_box = test($boxes)
    true
  end

  def test(array_of_tests)
    test_result = Array.new
    array_of_tests.each do |test|
      available_numbers = ('1'..'9').to_a
      open_index = nil
      test.each do |index|
        value = board[index]
        available_numbers = available_numbers - [value]
        open_index = index if value == '-'
      end
      if available_numbers.size == 1
        return unless open_index
        board[open_index] = available_numbers[0]
        @no_new_solutions = false
      end
      test_result << available_numbers
    end
    test_result
  end

  def result_of_inspecting_all_cells_for_quick_wins
    best_guess_cell = nil
    best_guess_options = nil
    lowest_option_count = 10
    for index in 0..80
      if board[index] == '-'
        available_options = get_available_options_for(index)
        case size = available_options.size
        when 0
          return false
        when 1
          board[index] = available_options[0]
          @no_new_solutions = false
        else
          if size < lowest_option_count
            lowest_option_count = size
            best_guess_cell = index
            best_guess_options = available_options
          end
        end
      end
    end
    {index: best_guess_cell, options: best_guess_options}
  end

  def get_available_options_for(index)
    @available_nums_for_row[$row_of_cell[index]] & @available_nums_for_col[$col_of_cell[index]] & @available_nums_for_box[$box_of_cell[index]]
  end

  def start_guessing
    @best_guess[:options].each do |guess|
      next_game=Sudoku.new(board_including(guess))
      next_game.solve
      if next_game.board_complete?
        @board = next_game.board
        return
      end
    end
  end

  def board_including(guess)
    new_board = board.dup
    new_board[@best_guess[:index]] = guess
    new_board
  end

end
