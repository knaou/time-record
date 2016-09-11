class AddValueTypeToEntryType < ActiveRecord::Migration
  def change
    add_column :entry_types, :value_type, :string, null: false, default: 'manual'
  end
end
