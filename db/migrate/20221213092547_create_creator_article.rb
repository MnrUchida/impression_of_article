class CreateCreatorArticle < ActiveRecord::Migration[7.0]
  def change
    create_table :creator_articles do |t|
      t.belongs_to :creator, null: false, foreign_key: true
      t.belongs_to :article, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
