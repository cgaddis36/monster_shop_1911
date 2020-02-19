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

      have_current_path '/profile'
      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as a merchant user" do

      visit '/login'

      fill_in 'email', with: 'alejandro@example.com'
      fill_in 'password', with: 'hamburger3'

      click_on 'Log In'

      have_current_path '/merchant/dashboard'
      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as an admin user" do

      visit '/login'

      fill_in 'email', with: 'kyle@example.com'
      fill_in 'password', with: 'hamburger04'

      click_on 'Log In'

      have_current_path '/admin/dashboard'
      expect(page).to have_content("You are now logged in!")
    end
    it "I am not able to login with bad credentials" do
      visit '/login'

      fill_in 'email', with: 'roman37@example.com'
      fill_in 'password', with: 'hamburger01'

      have_current_path '/login'
      expect(page).to have_content("Incorrect email/password")
    end
  end
end
