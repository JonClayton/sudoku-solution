require_relative 'sudoku'

game_number = 0
start = Time.now
File.readlines('sudoku_puzzles.txt').each do |variable|
  puts
  p "Game #{game_number += 1}"
  game = Sudoku.new(variable.chomp)
  puts
  game.solve
  puts game
end
finish = Time.now

puts "elapsed time: #{finish-start}"
