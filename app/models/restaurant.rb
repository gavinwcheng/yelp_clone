class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: {minimum: 3}, uniqueness: true

  def average_rating
    return 'N/A' if reviews.none?
    reviews.inject(0) {|memo, review| memo + review.rating} / reviews.length
    # reviews.average(:rating)
  end
end
