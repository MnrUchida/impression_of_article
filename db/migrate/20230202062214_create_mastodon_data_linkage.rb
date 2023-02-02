class CreateMastodonDataLinkage < ActiveRecord::Migration[7.0]
  def change
    create_table :mastodon_data_linkages do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :site, null: false
      t.string :token, null: false, limit: 512

      t.timestamps
    end
  end
end
