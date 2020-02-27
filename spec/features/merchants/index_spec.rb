require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @admin_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 2
                                )
      @merchant_user = User.create!(name: "Joseph",
                                  street_address: "123 Joey Way",
                                  city: "Joey",
                                  state: 'TX',
                                  zip_code: 12345,
                                  email: "records@example.com",
                                  password: "hamburger01",
                                  role: 1
                                )

      @default_user = User.create!(name: "Jerri",
                                  street_address: "123 Jerry Way",
                                  city: "Jees",
                                  state: 'TN',
                                  zip_code: 33333,
                                  email: "record@example.com",
                                  password: "hamburger01",
                                  role: 0
                                )
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)

      visit '/'

      click_on("All Merchants")

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end
    it 'I can cot see see a link to create a new merchant as a regular user' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

      visit '/merchants'

      expect(page).to_not have_link("New Merchant")
    end
    it 'I can cot see see a link to create a new merchant as a merchant_employee user' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      visit '/merchants'

      expect(page).to_not have_link("New Merchant")
    end
  end
end
