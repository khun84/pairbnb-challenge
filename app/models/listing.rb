class Listing < ApplicationRecord
    belongs_to :user
    belongs_to :location
    has_many :reservations

    mount_uploaders :images, ImagesUploader

    def self.verified
        where('verified = ?', true)
    end

    def self.not_verified
        where('verified = ?', false)
    end

    def self.search_by(param:{})
        city = param.fetch('city', '')



        check_in = param.fetch('check_in',Date.new(1980, 1 ,1))
        check_out = param.fetch('check_out', Date.new(1980, 1, 1))

        if check_in > check_out
            temp = check_in
            check_in = check_out
            check_out = temp
        end

        reserved_listings_id =  self.get_reserved_listings_id(check_in, check_out)
        if reserved_listings_id.blank?
            # return id as -1 so that any listings would fulfil this criteria
            reserved_listings_id = [-1]
        end

        verified.left_outer_joins(:location).where('locations.city ilike ? and listings.id not in (?)', "%#{city}%", reserved_listings_id)
    end

    def self.get_reserved_listings_id(check_in, check_out)
        Reservation.where('not (check_in >= ? or check_out <= ?)', check_out, check_in).pluck(:listing_id)
    end

end
