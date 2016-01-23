require_relative 'sudoku'

game_number = 0
File.readlines('sudoku_puzzles.txt').each do |variable|
  start = Time.now
  puts
  p "Game #{game_number += 1}"
  game = Sudoku.new(variable.chomp)
  puts
  puts game.solve!.scan(/.{9}/).join("\n")
  game.iterations
  finish = Time.now
  puts "elapsed time for game: #{finish-start}"
end
