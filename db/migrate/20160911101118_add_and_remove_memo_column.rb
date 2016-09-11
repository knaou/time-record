class AddAndRemoveMemoColumn < ActiveRecord::Migration
  def change
    remove_column :days, :memo
    add_column :time_entries, :memo, :text
  end
end
