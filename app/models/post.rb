class Post < ApplicationRecord
  belong_to :user

  # validates :name
  # validates :memo
end
