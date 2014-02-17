class GamesController < ApplicationController

  def new
    if File.exists?(".game")
      game_json = JSON.parse(File.read(".game"))
      @previous_x = game_json["x_player"]
      @previous_y = game_json["y_player"]
    else
      @previous_x = "http://protected-atoll-1298.herokuapp.com/moves"
      @previous_y = "http://protected-atoll-1298.herokuapp.com/moves"
    end
  end

  def create
    game_json = {x_player: params[:x_player], y_player: params[:y_player]}.to_json
    File.open('.game', 'w') {|file| file.write(game_json)}
    Board.create!
    redirect_to action: "index"
  end

  def index
    @board = Board.load
    game_json = JSON.parse(File.read(".game"))
    if @board.player_to_move == "X"
      move = HTTParty.get(game_json["x_player"], query: { board: @board.to_json }).parsed_response["move"]
    else
      move = HTTParty.get(game_json["y_player"], query: { board: @board.to_json }).parsed_response["move"]
    end
    @board.move!(move)
  end

  def move
    @board = Board.load
    @board.move!(params[:direction])
    redirect_to action: "index"
  end

end
