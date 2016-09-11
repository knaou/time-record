class EntryType < ActiveRecord::Base
  has_many :time_entries, dependent: :destroy

  scope :filter_by_default, -> { where(is_default: true) }
end
