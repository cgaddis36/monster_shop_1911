require 'rails_helper'

RSpec.describe "User registration" do

  it "can create a new user" do
    
    visit "/items" # to access a page with the nav bar

    click_on "Register"

    expect(current_path).to eq("/register")

    username = "George Costanza"
    street_address = "18 Market Street"
    city = "Denver"
    state = "CO"
    zip_code = "80203"
    email = "my_email@example.com"
    password = "test14"


    fill_in :name, with: username
    fill_in :street_address, with: street_address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip_code, with: zip_code
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on "Create User"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Welcome, #{name}!")
    expect(page).to have_content("You have registered successfully")
    # should we check that the current_user now exists? 
    # need to add a test for which the address entered is already in the user table.

  end

  it "returns a flash message if some fields are missing in the registration form" do
    
    visit "/items" # to access a page with the nav bar

    click_on "Register"

    expect(current_path).to eq("/register")

    name = "George Costanza"
    street_address = ""
    city = ""
    state = "CO"
    zip_code = "80203"
    email = "myemail@example.com"
    password = "test14"

    fill_in :name, with: username
    fill_in :street_address, with: street_address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip_code, with: zip_code
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on "Create User"

    expect(current_path).to eq("/register")

    expect(page).to have_content("Street address can't be blank and City can't be blank")
    # need to add a test for which the address entered is already in the user table.
  end
end

# User Story 10, User Registration

# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password

# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in

# User Story 11, User Registration Missing Details

# As a visitor
# When I visit the user registration page
# And I do not fill in this form completely,
# I am returned to the registration page
# And I see a flash message indicating that I am missing required fields