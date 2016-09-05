json.extract! time_entry, :id, :day_id, :type_id, :second, :created_at, :updated_at
json.url time_entry_url(time_entry, format: :json)