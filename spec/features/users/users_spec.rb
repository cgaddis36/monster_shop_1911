require 'rails_helper'

RSpec.describe "User registration" do

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
  end

  it "can create a new user" do
    
    visit "/items" 

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

    expect(page).to have_content("Welcome, #{username}!")
    expect(page).to have_content("You have registered successfully")
    # should we check that the current_user now exists? 
  end

  it "returns a flash message if some fields are missing in the registration form" do
    
    visit "/items" 

    click_on "Register"

    expect(current_path).to eq("/register")

    username = "George Costanza"
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
  end

  it "returns a flash message if the email entered at registration already exists in the database" do
    
    visit "/items" 

    click_on "Register"

    expect(current_path).to eq("/register")

    username = "George Costanza"
    street_address = "46 Market Street"
    city = "Denver"
    state = "CO"
    zip_code = "80203"
    email = "roman@example.com"
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

    expect(page).to have_content("Email has already been taken")
    expect(find_field(:name).value).to eq(username)
    expect(find_field(:street_address).value).to eq(street_address)
    expect(find_field(:city).value).to eq(city)
    expect(find_field(:state).value).to eq(state)
    expect(find_field(:zip_code).value).to eq(zip_code)
    expect(find_field(:email).value.blank?).to eq(true)
    expect(find_field(:password).value.blank?).to eq(true)
    expect(find_field(:password_confirmation).value.blank?).to eq(true)

  end

end
