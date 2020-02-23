require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
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
    @merchant_user = User.create!(name: "Alejandro",
                                street_address: "321 Jones Dr",
                                city: "Jonesville",
                                state: 'WI',
                                zip_code: 54321,
                                email: "alejandro@example.com",
                                password: "hamburger3",
                                role: 1
                              )
    @admin_user = User.create!(name: "Kyle",
                                street_address: "1243 Kyle Way",
                                city: "Kylesville",
                                state: 'TX',
                                zip_code: 12345,
                                email: "kyle@example.com",
                                password: "hamburger04",
                                role: 2
                              )
  end
  describe "when I visit the login page" do
    it "I am able to submit valid credentials and login as a default user" do

      visit '/login'

      fill_in 'email', with: 'roman@example.com'
      fill_in 'password', with: 'hamburger01'

      click_on 'Log In'

      expect(current_path).to eq('/profile')
      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as a merchant user" do

      visit '/login'

      fill_in 'email', with: 'alejandro@example.com'
      fill_in 'password', with: 'hamburger3'

      click_on 'Log In'

      expect(current_path).to eq('/merchant/dashboard')
      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as an admin user" do

      visit '/login'

      fill_in 'email', with: 'kyle@example.com'
      fill_in 'password', with: 'hamburger04'

      click_on 'Log In'

      expect(current_path).to eq('/admin')
      expect(page).to have_content("You are now logged in!")
    end
    it "I am not able to login with bad credentials" do
      visit '/login'

      fill_in 'email', with: 'roman37@example.com'
      fill_in 'password', with: 'hamburger01'

      click_on 'Log In'

      expect(current_path).to eq('/login')
      expect(page).to have_content("Incorrect email/password")
    end
  end
  describe 'as a current user when logged in' do
    it 'redirects when they visit the login path for admin' do
      admin_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman9@example.com",
                                  password: "hamburger09",
                                  role: 2
                                )
      visit '/login'

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password

      click_button "Log In"

      visit '/login'

      expect(current_path).to eq('/admin')
      expect(page).to have_content("You are already logged in!")
    end

    it 'redirects when they visit the login path for merchant' do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman8@example.com",
                                  password: "hamburger08",
                                  role: 1
                                )
      bike_shop.users << merchant_user

      visit '/login'

      fill_in :email, with: merchant_user.email
      fill_in :password, with: merchant_user.password

      click_button "Log In"

      visit '/login'
      expect(current_path).to eq('/merchant/dashboard')
      expect(page).to have_content("You are already logged in!")
    end

    it 'redirects when they visit the login path for a user' do
      default_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman7@example.com",
                                  password: "hamburger07",
                                  role: 0
                                )
      visit '/login'

      fill_in :email, with: default_user.email
      fill_in :password, with: default_user.password

      click_button "Log In"

      visit '/login'
      expect(current_path).to eq('/profile')
      expect(page).to have_content("You are already logged in!")
    end
  end
end
