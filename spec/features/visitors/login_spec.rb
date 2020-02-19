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

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

      expect(current_path).to eq('/profile')

      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as a merchant user" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      expect(current_path).to eq('/merchant/dashboard')
      expect(page).to have_content("You are now logged in!")
    end
    it "I am able to submit valid credentials and login as an admin user" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)

      expect(current_path).to eq('/admin/dashboard')
      expect(page).to have_content("You are now logged in!")
    end
    it "I am not able to login with bad credentials" do
      visit '/login'

      fill_in 'email', with: 'roman37@example.com'
      fill_in 'password', with: 'hamburger01'

      click_on("Login")

      expect(current_path).to eq('/login')
      expect(page).to have_content("Incorrect email/password")
    end
  end
end
