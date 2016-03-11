class AddDefaultToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :default, :boolean
  end
end
