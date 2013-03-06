class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.integer :number
      t.boolean :temporary
      t.integer :goals
      t.integer :efficiency
      t.integer :fouls
      t.integer :height
      t.integer :weight
      t.integer :birthyear
      t.integer :age
      t.integer :experience
      t.string :position
      t.text :description
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
