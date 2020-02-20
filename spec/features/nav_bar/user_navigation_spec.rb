
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a merchant' do
    it "I can see a link to my profile pages" do
      merchant_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman2@example.com",
                                  password: "hamburger02",
                                  role: 1
                                )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Profile")
        click_link 'Profile'
      end

      expect(current_path).to eq("/profile")
    end
  end
  describe 'As a User' do
    before(:each) do
      @default_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 0
                                )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
    end

    it "I see a nav bar with links to all pages I have access to" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
        expect(page).to_not have_content("Dashboard")
        expect(page).to_not have_content("All Users")
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart'
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link "Home"
      end

      expect(current_path).to eq('/')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "I don't have links to login and register" do

      visit "/"

      within 'nav' do
        expect(page).to_not have_content("Register")
        expect(page).to_not have_content("Login")
      end
    end

    it "I have a logout link" do

      visit "/"

      within 'nav' do
        expect(page).to have_content("Logout")
        click_link "Logout"
      end

      expect(current_path).to eq("/")
    end
  end
end
