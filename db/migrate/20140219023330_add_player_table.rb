class AddPlayerTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :url
      t.integer :wins, default: 0
      t.integer :losses, default: 0

      t.timestamps
    end
  end
end
