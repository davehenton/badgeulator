class AddDnToBadge < ActiveRecord::Migration
  def change
    add_column :badges, :dn, :string
  end
end
