class CreateArticle < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string "title", null: false
      t.string "url", null: false
      t.string "image_url"
      t.text "note"

      t.timestamps
    end
  end
end
