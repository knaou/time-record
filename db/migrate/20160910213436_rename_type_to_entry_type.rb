class RenameTypeToEntryType < ActiveRecord::Migration
  def change
    rename_table :types, :entry_types
    rename_column :time_entries, :type_id, :entry_type_id
  end
end
