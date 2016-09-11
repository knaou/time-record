class AddDiffReferenceToEntryType < ActiveRecord::Migration
  def change
    add_column :entry_types, :diff_entry_type1_id, :integer
    add_column :entry_types, :diff_entry_type2_id, :integer
  end
end
