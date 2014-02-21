class AddMatchTable < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :board_id
      t.integer :player1_id
      t.integer :player2_id
      t.datetime :finished_at

      t.timestamps
    end
  end
end
