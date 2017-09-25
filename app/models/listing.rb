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
end
