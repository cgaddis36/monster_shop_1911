require 'rails_helper'

RSpec.describe "Profile show page", type: :feature do
  before(:each) do
    @default_user = User.create!(name: "Saul Goodman",
      street_address: "123 Magic St",
      city: "Albuquerque",
      state: 'NM',
      zip_code: 44565,
      email: "bettercallsaul@example.com",
      password: "mike01",
      role: 0
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
  end
  it "shows all user data in profile show page" do

    visit '/'

    visit '/profile'

    expect(page).to have_content(@default_user.name)
    expect(page).to have_content(@default_user.street_address)
    expect(page).to have_content(@default_user.city)
    expect(page).to have_content(@default_user.state)
    expect(page).to have_content(@default_user.zip_code)
    expect(page).to have_content(@default_user.email)
    expect(page).to have_link("Edit Profile")
  end
  it "shows error messages if missing information on field" do

    visit '/profile'

    click_link("Edit Profile")
    fill_in :name, with: ""
    fill_in :email, with: ""
    click_on("Update Profile")
    expect(page).to have_content("Name can't be blank and Email can't be blank")
  end
end
