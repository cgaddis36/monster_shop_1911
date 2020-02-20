require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
  end
  describe 'roles' do
    it "can be created as a default user" do
      default_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 0
                                )

      expect(default_user.role).to eq('default')
      expect(default_user.default?).to be_truthy
    end

    it "can be created as admin" do
      admin_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 2
                                )

      expect(admin_user.role).to eq('admin')
      expect(admin_user.admin?).to be_truthy
    end

    it "can be created as a merchant user" do
      merchant_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 1
                                )

      expect(merchant_user.role).to eq('merchant_employee')
      expect(merchant_user.merchant_employee?).to be_truthy
    end
  end
end
