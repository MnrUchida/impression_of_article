class CreateMusicCreator < ActiveRecord::Migration[7.0]
  def change
    create_table :music_creators do |t|
      t.belongs_to :music, null: false, foreign_key: true
      t.belongs_to :creator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
