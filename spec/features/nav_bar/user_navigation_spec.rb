
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a User' do
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

    it "I don't have links to login and register" do
      within 'nav' do
        expect(page).to not_have("/register")
        expect(page).to not_have("/login")
      end
    end

  end
end
