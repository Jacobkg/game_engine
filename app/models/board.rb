class Board

  GRID_SIZE = 20

  attr_reader :game_id, :player_to_move, :x_score, :y_score, :x_position, :y_position
  def initialize(game_id, stars, x_position, y_position, x_score, y_score, player_to_move)
    @game_id = game_id
    @stars = stars
    @x_position = x_position
    @y_position = y_position
    @x_score = x_score
    @y_score = y_score
    @player_to_move = player_to_move
  end

  def self.create!
    board = Board.new(1, generate_random_stars, [0,0], [GRID_SIZE - 1, GRID_SIZE - 1], 0, 0, "X")
    board.save!
    board
  end

  def self.load
    return nil unless File.exists?(".board")
    board_json = JSON.parse(File.read('.board'))
    Board.new(board_json["game_id"], board_json["stars"], board_json["x_position"], board_json["y_position"],
              board_json["x_score"], board_json["y_score"], board_json["player_to_move"])
  end

  def to_json
    { game_id: game_id, stars: @stars, x_position: x_position, y_position: y_position,
      x_score: x_score, y_score: y_score, player_to_move: player_to_move }.to_json
  end

  def save!
    File.open('.board', 'w') {|file| file.write(self.to_json)}
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
      if @stars.include?([new_x, new_y])
        player_to_move == "X" ? @x_score += 1 : @y_score += 1
        @stars.delete([new_x, new_y])
      end
      update_player_position(new_x, new_y)
    end
    @player_to_move = other_player
    save!
  end

  def display_string
    board_output = ""
    0.upto(GRID_SIZE - 1) do |i|
      0.upto(GRID_SIZE - 1) do |j|
        if [i,j] == x_position
          board_output << "X"
        elsif [i,j] == y_position
          board_output << "Y"
        elsif @stars.include?([i,j])
          board_output << "*"
        else
          board_output << "-"
        end
      end
      board_output << "\n"
    end
    board_output
  end

  def self.generate_random_stars
    star_list = []
    loop do
      rand_x = rand(GRID_SIZE)
      rand_y = rand(GRID_SIZE)
      next if [rand_x, rand_y].in?([[0,0], [GRID_SIZE - 1, GRID_SIZE - 1]] + star_list)
      star_list << [rand_x, rand_y]
      break if star_list.count == 21
    end
    star_list.uniq
  end

  def player_coordinates(player)
    if player == "X"
      x_position
    else
      y_position
    end
  end

  private

    def update_player_position(new_x, new_y)
      if player_to_move == "X"
        @x_position = [new_x, new_y]
      else
        @y_position = [new_x, new_y]
      end
    end

    def legal_move?(new_x, new_y)
      return false if new_x < 0 || new_y < 0 || new_x >= GRID_SIZE || new_y >= GRID_SIZE
      return false if [new_x, new_y] == player_coordinates(other_player)
      return true
    end

    def other_player
      player_to_move == "X" ? "Y" : "X"
    end

end