class Reservation < ApplicationRecord
    belongs_to :listing
    belongs_to :user

    enum status: [:pending, :confirmed]

end
