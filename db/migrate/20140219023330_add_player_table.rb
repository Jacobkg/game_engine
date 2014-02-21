class AddPlayerTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :url
      t.integer :matches, default: 0
      t.integer :rating, default: 1000

      t.timestamps
    end
  end
end
