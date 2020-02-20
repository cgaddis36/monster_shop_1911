require 'rails_helper'

RSpec.describe 'User can log out' do
  describe "as a default user" do
     it 'can log out as a registered user' do
       default_user = User.create!(name: "Johnny",
                                   street_address: "123 Jonny Way",
                                   city: "Johnsonville",
                                   state: 'TN',
                                   zip_code: 12345,
                                   email: "roman@example.com",
                                   password: "hamburger01",
                                   role: 0
                                 )

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        click_on "Log Out"



        expect(current_path).to eq("/")
        expect(page).to have_content("You have been logged out")
        expect(page).to have_content("Cart: 0")
      end
    end
    describe 'as a merchant_employee' do
      it 'can logout as a merchant employee' do
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

        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        visit "/items/#{@tire.id}"
        click_on "Log Out"
        expect(current_path).to eq("/")
        expect(page).to have_content("You have been logged out")
      end
    end
    describe 'as an admin user' do
      it 'can log out as an admin user' do
        admin_user = User.create!(name: "Johnny",
                                    street_address: "123 Jonny Way",
                                    city: "Johnsonville",
                                    state: 'TN',
                                    zip_code: 12345,
                                    email: "roman@example.com",
                                    password: "hamburger01",
                                    role: 2
                                  )

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        visit "/items/#{@tire.id}"
        click_on "Log Out"
        expect(current_path).to eq("/")
        expect(page).to have_content("You have been logged out")
      end
    end 
  end
