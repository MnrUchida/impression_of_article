class CreateRandomizedImpressions < ActiveRecord::Migration[7.0]
  def change
    create_view :randomized_impressions
  end
end
