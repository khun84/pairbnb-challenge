class Listing < ApplicationRecord
    belongs_to :user
    belongs_to :location
    has_many :reservations

    mount_uploaders :images, ImagesUploader
end
