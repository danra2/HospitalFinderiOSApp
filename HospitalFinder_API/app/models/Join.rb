class Join < ActiveRecord::Base
    belongs_to :hospital
    belongs_to :insurance
end
