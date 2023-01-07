class CreateTagGroup < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_groups do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :sort_order, default: 0, null: false

      t.timestamps
    end
  end
end
