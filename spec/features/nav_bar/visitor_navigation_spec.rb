
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages I have access to" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
        expect(page).to not_have("/admin/dashboard")
        expect(page).to not_have("/merchant/dashboard")
        expect(page).to not_have("All Users")
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
        click_link 'Home Page'
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

    it "I have links to login and register in the nav bar" do
      within 'nav' do
        click_link("/register")
      end

      expect(current_path).to eq("/register")

      visit '/items'

      within 'nav' do
        click_link("/login")
      end

      expect(current_path).to eq("/login")
    end
  end
end

# As a visitor
# I see a navigation bar
# This navigation bar includes links for the following:
# - a link to return to the welcome / home page of the application ("/")
# - a link to browse all items for sale ("/items")
# - a link to see all merchants ("/merchants")
# - a link to my shopping cart ("/cart")
# - a link to log in ("/login")
# - a link to the user registration page ("/register")
#
# Next to the shopping cart link I see a count of the items in my cart
