require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a merchant' do
    before(:each) do
      @merchant_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 1
                                )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it "I can see a link to my profile pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Profile")
        click_link 'Profile'
      end

      expect(current_path).to eq("/profile")
    end

    it "sees the regular user links and the merchant dashboard link" do
      visit "/"

      within 'nav' do
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Cart")
        expect(page).to have_link("Home")
        expect(page).to have_link("Profile")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Merchant Dashboard")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end
  end
end
