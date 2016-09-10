class RenameWeightToPosition < ActiveRecord::Migration
  def change
    rename_column :types, :weight, :position
  end
end
