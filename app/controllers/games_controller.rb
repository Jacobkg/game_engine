class GamesController < ApplicationController

  def new
  end

  def create
    Resque.enqueue(RunMatchJob, params[:player_1], params[:player_2])
    redirect_to action: "new"
  end

  def new
  end

end
