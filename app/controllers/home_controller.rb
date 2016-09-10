require 'csv'

class HomeController < ApplicationController
  def index
    type_ids = params[:type_ids]
    @min = params[:min].present? ? params[:min].to_i : nil
    @max = params[:max].present? ? params[:max].to_i : nil
    @steps = params[:steps].present? ? params[:steps].to_i : nil
    @days = params[:days].present? ? params[:days].to_i : nil

    if type_ids && type_ids.count > 0
      @entry_types = EntryType.order(:position).where('id in (?)', type_ids)
    else
      @entry_types = EntryType.order(:position)
    end

    # TODO: move to lib/

    @day_labels = []
    @entry_label_map = Hash.new { |hash, key| hash[key] = [] }

    begin
        if @days.nil?
          Day.order(:day)
        else
          Day.order('day DESC').limit(@days).to_a.reverse
        end
    end.each do |day|
      # we can optimize this logic to 1 query
      max = @entry_types.map {|type| TimeEntry.where(day: day, entry_type: type).count }.max
      if max > 0
        max.times { |i|
          str = "#{day.day.month}/#{day.day.day}"
          if max > 1
            str += "_#{i+1}"
          end
          @day_labels << str
        }
      end

      @entry_types.each do |type|
        entries = TimeEntry.where(day: day, entry_type: type)
        entries.each do |te|
          @entry_label_map[type] << te.second
        end
        (0...(max - entries.count)).each {
          @entry_label_map[type] << nil
        }
      end
    end
  end

  def input
    day_id = params[:day_id]
    if day_id == 'today'
      @day = Day.find_or_create_by!(day: Date.today)
    elsif day_id
      @day = Day.find(day_id)
    else
      @day = Day.order(:day).last || Day.create!(day: Date.today)
    end
  end

  def other

  end

  def download_csv
    csv = CSV.generate do |csv|
      types = EntryType.order(:position)
      csv << ['day', 'index'] + types.map(&:name)

      Day.all.each do |day|
        entries = TimeEntry.array_by_day(day.id)
        entries.each_with_index do |entry, index|
          csv << [day.day, index + 1] + entry
        end
      end
    end

    send_data csv
  end

end
