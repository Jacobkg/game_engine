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

  def move
    board_string = File.read(".board")
    board = board_string.lines.map {|line| line.strip.split("")}
    board_x, board_y = find_coordinates(board, "X")
    board[board_x][board_y] = "-"
    if params[:direction] == "right"
      board[board_x][[9, board_y+1].min] = "X"
    elsif params[:direction] == "left"
      board[board_x][[0, board_y-1].max] = "X"
    elsif params[:direction] == "down"
      board[[9, board_x + 1].min][board_y] = "X"
    else
      board[[0, board_x - 1].max][board_y] = "X"
    end
    @board_string = draw_board(board)
    File.open('.board', 'w') {|file| file.write(@board_string)}
    redirect_to action: "index"
  end

  private

  def find_coordinates(board, piece)
    0.upto(9) do |i|
      0.upto(9) do |j|
        return [i,j] if board[i][j] == piece
      end
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