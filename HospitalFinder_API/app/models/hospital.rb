class Hospital < ActiveRecord::Base
    has_many :images
    has_many :joins
    has_many :insurances, through: :joins
end
