require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As an Admin User' do
    before(:each) do
      @admin_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 2
                                )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
    end

    it "sees the regular user links and the merchant dashboard link" do

      visit "/"

      within 'nav' do
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Home")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Admin Dashboard")
        expect(page).to have_link("All Users")
        expect(page).to_not have_link("Merchant Dashboard")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Cart")
      end

    end

  end
end
