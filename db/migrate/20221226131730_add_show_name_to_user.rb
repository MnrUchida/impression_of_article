class AddShowNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :show_name, :boolean, default: false
  end
end
