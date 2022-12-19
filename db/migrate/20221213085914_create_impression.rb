class CreateImpression < ActiveRecord::Migration[7.0]
  def change
    create_table :impressions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :article, null: false, foreign_key: true
      t.string "summary", null: false
      t.text "detail"

      t.timestamps
    end
  end
end
