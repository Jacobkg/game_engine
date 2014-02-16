class Board

  GRID_SIZE = 20

  attr_reader :board, :player_to_move, :x_score, :y_score
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
    board_x, board_y = player_coordinates(player_to_move)
    if direction == "right"
      new_x, new_y = board_x, board_y + 1
    elsif direction == "left"
      new_x, new_y = board_x, board_y - 1
    elsif direction == "down"
      new_x, new_y = board_x + 1, board_y
    else
      new_x, new_y = board_x - 1, board_y
    end
    if legal_move?(new_x, new_y)
      if @board[new_x][new_y] == "*"
        player_to_move == "X" ? @x_score += 1 : @y_score += 1
      end
      @board[board_x][board_y] = "-"
      @board[new_x][new_y] = player_to_move
    end
    @player_to_move = other_player
    save!
  end

  def display_string
    board_output = ""
    0.upto(GRID_SIZE - 1) do |i|
      0.upto(GRID_SIZE - 1) do |j|
        board_output << @board[i][j]
      end
      board_output << "\n"
    end
    board_output
  end

  def self.generate_random_board
    board = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { "-" } }
    GRID_SIZE.times do
      rand_x = rand(GRID_SIZE)
      rand_y = rand(GRID_SIZE)
      board[rand_x][rand_y] = "*"
    end
    board[0][0] = "X"
    board[GRID_SIZE - 1][GRID_SIZE - 1] = "O"
    board
  end

  def player_coordinates(player)
    0.upto(GRID_SIZE - 1) do |i|
      0.upto(GRID_SIZE - 1) do |j|
        return [i,j] if @board[i][j] == player
      end
    end
  end

  private

    def legal_move?(new_x, new_y)
      return false if new_x < 0 || new_y < 0 || new_x >= GRID_SIZE || new_y >= GRID_SIZE
      return false if [new_x, new_y] == player_coordinates(other_player)
      return true
    end

    def other_player
      player_to_move == "X" ? "O" : "X"
    end

end