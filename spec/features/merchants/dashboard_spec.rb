require 'rails_helper'

RSpec.describe "As a merchant employee", type: :feature do 

  describe 'when I visit my merchant dashboard' do 

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
      
    end

    it 'has a link to view the merchant items' do 

      visit "/login"

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_on "Log In"
      visit '/merchant/dashboard'
      click_on("My Items")
      expect(current_path).to eq("/merchant/items")
    end

  end
end