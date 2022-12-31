class AddUploadedImageUrlToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :uploaded_image_url, :string
  end
end
