class AddDefaultFlagToEntryType < ActiveRecord::Migration
  def change
    add_column :entry_types, :is_default, :boolean, default: false

  end
end
