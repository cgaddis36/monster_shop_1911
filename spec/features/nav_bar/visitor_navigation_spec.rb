
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages I have access to" do
      visit '/merchants'

      within 'nav' do
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
