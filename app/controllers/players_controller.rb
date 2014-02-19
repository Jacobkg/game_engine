class PlayersController < ApplicationController

  def new
  end

  def create
    player = Player.new(params[:player].permit(:name, :url))
    player.save!
    redirect_to action: 'index'
  end

  def index
    @players = Player.all
  end

end