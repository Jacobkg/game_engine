class MatchesController < ApplicationController

  def new
  end

  def create
    match = Match.new(params[:match].permit(:player1_id, :player2_id))
    board = Board.generate_random
    match.board = board
    match.save!
    Resque.enqueue(RunMatchJob, match.id)
    redirect_to match_path(match)
  end

  def show
    match = Match.find(params[:id])
    @board = match.board
  end

end