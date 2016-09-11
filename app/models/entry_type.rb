class EntryType < ActiveRecord::Base
  has_many :time_entries, dependent: :destroy

  # for Diff patter
  belongs_to :diff_entry_type1, class_name: 'EntryType', foreign_key: 'diff_entry_type1_id'
  belongs_to :diff_entry_type2, class_name: 'EntryType', foreign_key: 'diff_entry_type2_id'

  default_scope -> { order(:position) }

  scope :filter_by_default, -> { where(is_default: true) }
  scope :manual,  -> { where(value_type: 'manual') }
  scope :diff,  -> { where(value_type: 'diff') }

  def by_day(day, walked_entry_type = [])
    raise "Detect loop" if walked_entry_type.include?(self)
    walked_entry_type << self

    #TODO: Should impls by using STI
    case value_type
      when 'manual'
        time_entries.where(day: day)
      when 'diff'
        entries1 = diff_entry_type1.by_day(day, walked_entry_type)
        entries2 = diff_entry_type2.by_day(day, walked_entry_type)
        entries1.zip(entries2).select {|v1,v2| v1 && v2}.map do |e1, e2|
          TimeEntry.new_as_diff(day, self, e1, e2)
        end
      else
        raise "Unknwon type: #{value_type}"
    end

  end

end
