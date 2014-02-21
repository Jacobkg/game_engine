class RunMatchJob
  @queue = :match

  def self.perform(match_id)
    match = Match.find(match_id)
    board = match.board
    board.save_stars

    #Game1
    play_game(board, match.player1, match.player2)

    #Game2
    board.reset!
    play_game(board, match.player2, match.player1)

    match.player1.matches += 1
    match.player2.matches += 1
    match.player1.save!
    match.player2.save!
  end

  def self.play_game(board, x_player, y_player)
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
    x_elo_player = Elo::Player.new(rating: x_player.rating)
    y_elo_player = Elo::Player.new(rating: y_player.rating)
    if board.winner == "X"
      x_elo_player.wins_from(y_elo_player)
    else
      y_elo_player.wins_from(x_elo_player)
    end
    x_player.update_attributes! rating: x_elo_player.rating
    y_player.update_attributes! rating: y_elo_player.rating
  end

end