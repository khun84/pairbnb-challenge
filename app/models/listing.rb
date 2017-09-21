class Listing < ApplicationRecord
    belongs_to :user
    belongs_to :location

    mount_uploaders :images, ImagesUploader
end
