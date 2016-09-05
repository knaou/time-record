class Day < ActiveRecord::Base
  has_many :time_entries, dependent: :destroy

end
