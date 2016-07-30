class Insurance < ActiveRecord::Base
    has_many :joins
    has_many :hospitals, through: :joins
end
