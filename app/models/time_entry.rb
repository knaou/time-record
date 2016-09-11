class TimeEntry < ActiveRecord::Base
  belongs_to :day
  belongs_to :entry_type

  def self.new_as_diff(day, entry_type, entry1, entry2)
    self.new(day: day, entry_type: entry_type, second: ((entry1.second && entry2.second) ? (entry1.second - entry2.second) : nil))
  end

  # For CSV
  # # TODO: impls here as commonly method
  def self.entries_by_day(day_id, type_ids = nil)
    day = Day.find(day_id)
    entries = where(day_id: day_id)
    if type_ids.blank?
      type_ids = EntryType.all.map(&:id)
    end

    max_count = type_ids.map{|type_id| entries.where(entry_type_id: type_id).count }.max
    type_array = {}
    type_ids.map{|id| EntryType.find(id) }.each do |type|
      type_array[type.id] = type.entries_by_day(day)
    end

    ret = []
    (0...max_count).each do |i|
      ret << type_ids.map {|type_id| (type_array[type_id].count < i) ? nil : type_array[type_id][i] }
    end

    ret
  end
end
