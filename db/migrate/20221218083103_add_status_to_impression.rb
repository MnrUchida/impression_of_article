class AddStatusToImpression < ActiveRecord::Migration[7.0]
  def change
    add_column :impressions, :status, :integer
  end
end
