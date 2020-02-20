require 'rails_helper'

RSpec.describe "as a registered user visiting profile page" do
  it "can click a link to change their password" do
    user = create(:random_user, password: "password", password_confirmation: "password")

    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/profile"
    click_link("Change My Password")
    expect(current_path).to eq("/user/password/edit")

    password = "cool_beans"
    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_button "Create New Password"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Password Updated Successfully")

    click_link "Log Out"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: password
    click_button "Log In"
    expect(current_path).to eq("/profile")
    expect(page).to have_content("You are now logged in!")
  end

  it "returns error if password and password confirmation are different" do
    user = create(:random_user, password: "password", password_confirmation: "password")

    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Log In"

    visit "/profile"

    click_link("Change My Password")
    expect(current_path).to eq("/user/password/edit")

    password = "new_password"

    fill_in :password, with: password
    fill_in :password_confirmation, with: "i_want_chipotle"

    click_button "Create New Password"
  end
end
