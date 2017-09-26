class Reservation < ApplicationRecord
    belongs_to :listing
    belongs_to :user
    before_save :set_days_of_stay, :set_price, on: :create

    validate :validate_date, :validate_availability, :validate_should_not_book_by, :validate_num_of_guests
    enum status: [:pending, :confirmed]

    def self.show_host_reservations(host_id)
        listings_belong_to_host = User.find(host_id).listings.pluck(:id)
        where('listing_id in (?)', listings_belong_to_host).order('check_in')
    end

    def self.check_in_from_today
        where('check_in >= ?', Date.today).order('check_in')
    end

    def self.check_out_from_today
        where('check_out >= ?', Date.today).order('check_in')
    end

    def self.check_in_today
        where('check_in = ?', Date.today)
    end

    def self.check_out_today
        where('check_out = ?', Date.today)
    end



    private

    def set_days_of_stay
        self.days = (self.check_out - self.check_in).to_i
    end

    def set_price
        base_price = Listing.find(self.listing_id).base_price
        self.price = self.days * base_price
    end

    def validate_date
        if self.check_in >= self.check_out
            errors.add(:check_out, "date can't be smaller than check in date")
        end
    end

    def validate_availability
        sql_string = "listing_id = ? and not (check_in >= ? or check_out <= ?)"
        if Reservation.where(sql_string, self.listing_id, self.check_out, self.check_in).exists?
            errors.add(:check_in, "the dates that you wish to book are not available. Please try other dates.")
        end
    end

    def validate_should_not_book_by
        if self.user.moderator?
            errors.add(:user_id, 'Moderators are not allowed to make booking.')
        elsif self.listing.user_id == self.user_id
            errors.add(:user_id, 'The host are not allowed to book his/her own listings')
        end
    end

    def validate_num_of_guests
        if !(self.num_of_guests >=1 and self.num_of_guests <= self.listing.person_count)
            errors.add(:num_of_guests, 'Please select the correct number of guests!')
        end
    end

end
