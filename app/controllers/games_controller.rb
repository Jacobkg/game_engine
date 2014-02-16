class GamesController < ApplicationController

  def index
    @board = Board.load || Board.create!
  end

  def move
    @board = Board.load
    @board.move!(params[:direction])
    redirect_to action: "index"
  end

end
