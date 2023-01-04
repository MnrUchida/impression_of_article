class AddImageDataToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :image_data, :binary
    add_column :articles, :content_type, :string
  end
end
