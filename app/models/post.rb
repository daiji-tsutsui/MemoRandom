class Post < ApplicationRecord
  belongs_to :user

  validates :name, length: { maximum: 255 }
  validates :memo, presence: true

  mount_uploader :memo, MemoUploader
end
