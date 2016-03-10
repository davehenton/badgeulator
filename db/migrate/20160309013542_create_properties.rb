class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :artifact, index: true, foreign_key: true
      t.string :name
      t.string :value

      t.timestamps null: false
    end
  end
end
