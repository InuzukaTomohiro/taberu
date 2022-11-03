class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nick_name,    uniqueness: true, length: { in: 1..20 }
  validates :phone_number, uniqueness: true, length: { in: 10..11 }, numericality: :only_integer

  has_many :user_meats,    dependent: :destroy
  has_many :posts,         dependent: :destroy
  has_many :comments,      dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :relationships,            class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships,            source: :followed
  has_many :followers,  through: :reverse_of_relationships, source: :follower
  
  has_one_attached :profile_image
  
  def get_profile_image(width, height)
    unless item_image.attached?
      file_path = Rails.root.join("app/assets/images/default-image.jpeg")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpeg", content_type: "image/jpeg")
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end


end
