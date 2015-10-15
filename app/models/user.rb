class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :restaurants
  has_many :reviews
  has_many :reviewed_restaurants, through: :reviews, source: :restaurants

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
