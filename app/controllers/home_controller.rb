require 'csv'

class HomeController < ApplicationController
  def index
    type_ids = params[:type_ids]
    @min = params[:min].present? ? params[:min].to_i : nil
    @max = params[:max].present? ? params[:max].to_i : nil
    @steps = params[:steps].present? ? params[:steps].to_i : nil
    @days = params[:days].present? ? params[:days].to_i : nil
    @base = params[:base].present? ? params[:base].to_i : nil

    if type_ids && type_ids.count > 0
      @entry_types = EntryType.where('id in (?)', type_ids)
    else
      @entry_types = EntryType.filter_by_default
    end

    # TODO: move to lib/

    @day_labels = []
    @entry_label_map = Hash.new { |hash, key| hash[key] = [] }

    @total_count = 0

    begin
        if @days.nil?
          Day.order(:day)
        else
          Day.order('day DESC').limit(@days).to_a.reverse
        end
    end.each do |day|
      # we can optimize this logic to 1 query
      max = @entry_types.map {|type| type.entries_by_day(day).count }.max
      if max &&  max > 0
        max.times { |i|
          str = "#{day.day.month}/#{day.day.day}"
          if max > 1
            str += "_#{i+1}"
          end
          @day_labels << str
        }
      end

      @entry_types.each do |type|
        entries = type.entries_by_day(day)
        entries.each do |te|
          @entry_label_map[type] << [te.second, te.memo]
        end
        (0...(max - entries.count)).each {
          @entry_label_map[type] << nil
        }
      end

      @total_count += max
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
      csv << ['day', 'index'] + EntryType.all.map(&:name)

      Day.all.each do |day|
        entries = TimeEntry.entries_by_day(day.id)
        entries.each_with_index do |es, index|
          csv << [day.day, index + 1] + es.map{|e| e.try(&:second)}
        end
      end
    end

    send_data csv.encode(Encoding::SJIS),
              filename: 'all-data.csv',
              type: 'text/csv; charset=shift_jis'
  end

  def download_memo_csv
    csv = CSV.generate do |csv|
      csv << ['day', 'index', 'data-type', 'Memo']

      Day.all.each do |day|
        entries = TimeEntry.entries_by_day(day.id)
        entries.each_with_index do |es, index|
          es.select{|e| e.try(&:memo).present? }.each do |e|
            csv << [day.day, index + 1, e.entry_type.name, e.memo]
          end
        end
      end
    end

    send_data csv.encode(Encoding::SJIS),
              filename: 'memo-data.csv',
              type: 'text/csv; charset=shift_jis'
  end

end
