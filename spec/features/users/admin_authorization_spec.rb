require 'rails_helper'

RSpec.describe 'As an admin' do
  it "does not allow me to certain pages" do
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

    expect(admin_user.role).to eq('admin')

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
