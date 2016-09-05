class HomeController < ApplicationController
  def index
    type_ids = params[:type_ids]

    days = Day.order(:day)
    if type_ids && type_ids.count > 0
      @types = Type.order(:weight).where('id in (?)', type_ids)
    else
      @types = Type.order(:weight)
    end

    @day_labels = []
    @entry_label_map = Hash.new { |hash, key| hash[key] = [] }

    days.each do |day|
      @day_labels << "#{day.day.month}/#{day.day.day}"
      @types.each do |type|
        te = TimeEntry.where(day: day, type: type).first
        @entry_label_map[type] << (te.present? ? te.second : 0)
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

end
