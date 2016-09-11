class TimeEntry < ActiveRecord::Base
  belongs_to :day
  belongs_to :entry_type

  def self.array_by_day(day_id, type_ids = nil)
    entries = where(day_id: day_id)
    if type_ids.blank?
      type_ids = EntryType.all.map(&:id)
    end

    max_count = type_ids.map{|type_id| entries.where(entry_type_id: type_id).count }.max
    type_array = {}
    type_ids.each do |type_id|
      es = entries.where(entry_type_id: type_id)
      type_array[type_id] = es.map(&:second)
    end

    ret = []
    (0...max_count).each do |i|
      ret << type_ids.map {|type_id| (type_array[type_id].count < i) ? '' : (type_array[type_id][i] || '') }
    end

    ret
  end
end
