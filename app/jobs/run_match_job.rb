class RunMatchJob
  @queue = :match

  def self.perform(player_1_id, player_2_id)
    player_1 = Player.find(player_1_id)
    player_2 = Player.find(player_2_id)

    #Game1
    board = Board.generate_random
    board_2 = board.copy

    x_player, y_player = player_1, player_2
    loop do
      break if board.winner
      if board.player_to_move == "X"
        move = HTTParty.get(x_player.url, query: { board: board.to_json }).parsed_response["move"]
      else
        move = HTTParty.get(y_player.url, query: { board: board.to_json }).parsed_response["move"]
      end
      board.move!(move)
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

    #Game 2
    board = board_2
    x_player, y_player = player_2, player_1
    loop do
      break if board.winner
      if board.player_to_move == "X"
        move = HTTParty.get(x_player.url, query: { board: board.to_json }).parsed_response["move"]
      else
        move = HTTParty.get(y_player.url, query: { board: board.to_json }).parsed_response["move"]
      end
      board.move!(move)
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