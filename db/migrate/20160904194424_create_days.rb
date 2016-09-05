class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :day
      t.string :memo

      t.timestamps null: false
    end
  end
end
