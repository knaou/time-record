class TimeEntriesController < ApplicationController

  def create
    TimeEntry.create(time_entry_params)
    redirect_to home_input_path(day_id: params[:day_id]), notice: 'Time entry was successfully created.'
  end

  def add_time
    day_id = params[:day_id]
    type_id = params[:type_id]
    second = params[:second]
    raise "Illegal arguments" if day_id.nil? || type_id.nil?
    second = nil if second.blank?

    render json: TimeEntry.create!(day_id: day_id, type_id: type_id, second: second)
  end

  def delete_time
    entry_id = params[:entry_id]
    raise "Illegal arguments" if entry_id.nil?

    TimeEntry.find(entry_id).destroy
    render json: {result: 'ok'}
  end

  def entries_by
    day_id = params['day_id']
    raise "day_id is not set" if day_id.nil?

    ret = []
    Type.order(:weight).each do |type|
      ret << {
          id: type.id,
          type_name: type.name,
          time_entries: TimeEntry.where(day_id: day_id.to_i, type_id: type.id)
      }
    end

    render json: ret
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to time_entries_url, notice: 'Time entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:day_id, :type_id, :second)
    end
end
