require 'rails_helper'

RSpec.describe 'As a merchant' do
  it "does not allow me to access admin pages" do
    merchant_user = User.create!(name: "Johnny",
                                street_address: "123 Jonny Way",
                                city: "Johnsonville",
                                state: 'TN',
                                zip_code: 12345,
                                email: "roman2@example.com",
                                password: "hamburger02",
                                role: 1
                              )
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    expect(merchant_user.role).to eq('merchant_employee')

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
