class RunMatchJob
  @queue = :match

  def self.perform(match_id)
    match = Match.find(match_id)
    player1 = match.player1
    player2 = match.player2
    board = match.board
    board.save_stars

    #Game1
    x_player, y_player = player1, player2
    loop do
      break if board.winner
      if board.player_to_move == "X"
        move = HTTParty.get(x_player.url, query: { board: board.to_json }).parsed_response["move"]
      else
        move = HTTParty.get(y_player.url, query: { board: board.to_json }).parsed_response["move"]
      end
      board.move!(move)
      sleep 0.1
    end
    if board.winner == "X"
      x_player.wins += 1
      y_player.losses += 1
    else
      y_player.wins += 1
      x_player.losses += 1
    end
    x_player.save!
    y_player.save!

    #Game2
    board.reset!
    x_player, y_player = player2, player1
    loop do
      break if board.winner
      if board.player_to_move == "X"
        move = HTTParty.get(x_player.url, query: { board: board.to_json }).parsed_response["move"]
      else
        move = HTTParty.get(y_player.url, query: { board: board.to_json }).parsed_response["move"]
      end
      board.move!(move)
      sleep 0.1
    end
    if board.winner == "X"
      x_player.wins += 1
      y_player.losses += 1
    else
      y_player.wins += 1
      x_player.losses += 1
    end
    x_player.save!
    y_player.save!
  end
end