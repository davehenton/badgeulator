class AddFirstNameToBadge < ActiveRecord::Migration
  def change
    add_column :badges, :first_name, :string
    rename_column :badges, :name, :last_name
  end
end
