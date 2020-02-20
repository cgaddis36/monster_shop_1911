class User < ApplicationRecord 

  validates_presence_of :name, :street_address, :city, :state, :zip_code
  validates_presence_of :password, require: true
  validates :email, uniqueness: true, presence: true

  validates_confirmation_of :password, :message => "Passwords should match"

  has_secure_password

  enum role: %w(default merchant admin)

end