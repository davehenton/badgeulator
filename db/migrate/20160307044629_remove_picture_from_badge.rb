class RemovePictureFromBadge < ActiveRecord::Migration
  def change
    remove_column :badges, :picture, :binary
  end
end
