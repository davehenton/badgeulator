class AddUpdateThumbnailToBadge < ActiveRecord::Migration
  def change
    add_column :badges, :update_thumbnail, :boolean, default: true
  end
end
