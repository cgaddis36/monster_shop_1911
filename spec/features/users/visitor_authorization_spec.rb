require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  it "Can't go to unauthorized pages" do
    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/merchant/dashboard'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/profile'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
