class Board

  attr_reader :player_to_move, :x_score, :y_score
  def initialize(board, player_to_move, x_score, y_score)
    @board = board
    @player_to_move = player_to_move
    @x_score = x_score
    @y_score = y_score
  end

  def self.create!
    board = Board.new(generate_random_board, "X", 0, 0)
    board.save!
    board
  end

  def self.load
    return nil unless File.exists?(".board")
    board_json = JSON.parse(File.read('.board'))
    board = board_json["board"].lines.map {|line| line.strip.split("")}
    Board.new(board, board_json["player"], board_json["x_score"], board_json["y_score"])
  end

  def save!
    board_json = { board: display_string, player: player_to_move, x_score: x_score, y_score: y_score }.to_json
    File.open('.board', 'w') {|file| file.write(board_json)}
  end

  def move!(direction)
    board_x, board_y = player_coordinates
    if direction == "right"
      new_x, new_y = board_x, [9, board_y+1].min
    elsif direction == "left"
      new_x, new_y = board_x, [0, board_y-1].max
    elsif direction == "down"
      new_x, new_y = [9, board_x + 1].min, board_y
    else
      new_x, new_y = [0, board_x - 1].max, board_y
    end
    if @board[new_x][new_y] == "*"
      player_to_move == "X" ? @x_score += 1 : @y_score += 1
    end
    @board[board_x][board_y] = "-"
    @board[new_x][new_y] = player_to_move
    @player_to_move = player_to_move == "X" ? "O" : "X"
    save!
  end

  def display_string
    board_output = ""
    0.upto(9) do |i|
      0.upto(9) do |j|
        board_output << @board[i][j]
      end
      board_output << "\n"
    end
    board_output
  end

  def self.generate_random_board
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

  private

    def player_coordinates
      0.upto(9) do |i|
        0.upto(9) do |j|
          return [i,j] if @board[i][j] == player_to_move
        end
      end
    end

end