class CreateGames < ActiveRecord::Migration

  def change
    return if table_exists? :games
    create_table :games do |t|
      t.string :name
      t.string :score
      t.datetime :date
      t.integer :result

      t.timestamps
    end
  end
end
