class AddDefaults < ActiveRecord::Migration
  def change
    change_column :sides, :order, :integer, default: 0
    change_column :artifacts, :order, :integer, default: 0
  end
end
