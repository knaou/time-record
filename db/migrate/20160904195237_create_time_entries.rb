class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :day_id
      t.integer :type_id
      t.float :second

      t.timestamps null: false
    end
  end
end
