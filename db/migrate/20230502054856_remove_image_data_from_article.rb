class RemoveImageDataFromArticle < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :image_data, :binary
    remove_column :articles, :content_type, :string
  end
end
