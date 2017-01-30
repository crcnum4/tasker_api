class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uuid
      t.string :model
      t.string :token
      t.boolean :confirmed
      t.string :name

      t.timestamps null: false
    end
  end
end
