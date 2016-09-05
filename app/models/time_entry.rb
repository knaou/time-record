class TimeEntry < ActiveRecord::Base
  belongs_to :day
  belongs_to :type

end
