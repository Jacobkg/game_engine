class GamesController < ApplicationController

  def index
    if File.exists?(".board")
      @board_string = File.read('.board')
    else
      board = generate_board
      @board_string = draw_board(board)
      File.open('.board', 'w') {|file| file.write(@board_string)}
    end
  end

  def generate_board
    board = Array.new(10) { Array.new(10) { "-" } }
    10.times do
      rand_x = rand(10)
      rand_y = rand(10)
      board[rand_x][rand_y] = "*"
    end
    board[0][0] = "X"
    board[9][9] = "O"
    board
  end

  def draw_board(board)
    board_output = ""
    0.upto(9) do |i|
      0.upto(9) do |j|
        board_output << board[i][j]
      end
      board_output << "\n"
    end

    board_output
  end

end