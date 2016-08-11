class CreateVideos < ActiveRecord::Migration
  def change
      create_table :videos do |t|
      t.string :avatar_content_type
      t.string :avatar_file_name
      t.integer :avatar_file_size
      t.float :duration, null: false, default: 0.0
      t.timestamps
    end
      

      add_index :videos, :avatar_file_name

  end
end