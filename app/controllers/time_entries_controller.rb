class TimeEntriesController < ApplicationController

  def add_time
    day_id = params[:day_id]
    entry_type_id = params[:entry_type_id]
    second = params[:second]
    raise "Illegal arguments" if day_id.nil? || entry_type_id.nil?
    second = nil if second.blank?

    render json: TimeEntry.create!(day_id: day_id, entry_type_id: entry_type_id, second: second)
  end

  def delete_time
    entry_id = params[:entry_id]
    raise "Illegal arguments" if entry_id.nil?

    TimeEntry.find(entry_id).destroy
    render json: {result: 'ok'}
  end

  def editable_entries_by
    day_id = params['day_id']
    raise "day_id is not set" if day_id.nil?

    ret = []
    EntryType.manual.each do |type|
      ret << {
          id: type.id,
          type_name: type.name,
          time_entries: type.by_day(Day.find(day_id))
      }
    end

    render json: ret
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:day_id, :type_id, :second)
    end
end
