class AddBoardTable < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :x_score
      t.integer :y_score
      t.string :x_position
      t.string :y_position
      t.text :stars
      t.string :player_to_move

      t.timestamps
    end
  end
end
