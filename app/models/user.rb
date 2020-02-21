class User < ApplicationRecord

  validates_presence_of :name, :street_address, :city, :state, :zip_code
  validates :email, uniqueness: true, presence: true

  validates_confirmation_of :password, :message => "Passwords should match"

  belongs_to :merchant, optional: true

  has_secure_password

  enum role: %w(default merchant_employee admin)

end
