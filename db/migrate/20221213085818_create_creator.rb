class CreateCreator < ActiveRecord::Migration[7.0]
  def change
    create_table :creators do |t|
      t.string "name", null: false
      t.string "url"
      t.text "note"

      t.timestamps
    end
  end
end
