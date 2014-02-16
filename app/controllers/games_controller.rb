class GamesController < ApplicationController

  def index
    @board = Board.load || Board.create!
  end

  def move
    @board = Board.load
    @board.move!(params[:direction])
    ai_move = determine_ai_move
    @board.move!(ai_move)
    redirect_to action: "index"
  end

  def determine_ai_move
    board_array = @board.board
    x, y = @board.player_coordinates("O")
    Rails.logger.debug("Coord: #{[x,y].inspect}")
    Rails.logger.debug(board_array[x])
    if board_array[x].include?("*")
      if board_array[x][0..y].include?("*")
        return "left"
      else
        return "right"
      end
    else
      return "up"
    end
  end

end
