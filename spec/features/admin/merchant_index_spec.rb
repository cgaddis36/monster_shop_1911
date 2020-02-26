  require 'rails_helper'

  describe "As an admin user" do
    describe "I visit the merchant's index page" do
      before :each do
        @merchant1 = Merchant.create(name: "Meg's Boat Shop", address: '12 Water Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @merchant2 = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Alberta', state: 'GA', zip: 56239)
        @merchant3 = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 60203, status: "disabled")

        @admin_user = User.create!(name: "Bob T Builder",
                                    street_address: "123 Contractor Blvd.",
                                    city: "Fixit",
                                    state: 'TN',
                                    zip_code: "45678",
                                    email: "yeswecan@example.com",
                                    password: "hammertime7",
                                    role: 2
                                  )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      end

      it "can see all the merchant's in the system and their information with a link to merchant dashboard" do
        visit '/admin/merchants'

      within "#merchant-#{@merchant1.id}" do
        expect(page).to have_content(@merchant1.city)
        expect(page).to have_content(@merchant1.state)
        click_on "#{@merchant1.name}"
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")

      visit '/admin/merchants'

      within "#merchant-#{@merchant2.id}" do
        expect(page).to have_content(@merchant2.city)
        expect(page).to have_content(@merchant2.state)
        click_on "#{@merchant2.name}"
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant2.id}")

      visit '/admin/merchants'

      within "#merchant-#{@merchant3.id}" do
        expect(page).to have_content(@merchant3.city)
        expect(page).to have_content(@merchant3.state)
        click_on "#{@merchant3.name}"
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant3.id}")
    end

    it "can see a disable button for enabled merchants and enable button for disabled merchants" do
      visit '/admin/merchants'

      within "#merchant-#{@merchant1.id}" do
        expect(page).to have_button("Disable")
      end

      within "#merchant-#{@merchant2.id}" do
        expect(page).to have_button("Disable")
      end

      within "#merchant-#{@merchant3.id}" do
        expect(page).to have_button("Enable")
      end
    end
  end
end





# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled
