require 'rails_helper'

RSpec.describe 'As an admin' do
  before(:each) do
    @admin_user = User.create!(name: "Johnny",
      street_address: "123 Jonny Way",
      city: "Johnsonville",
      state: 'TN',
      zip_code: 12345,
      email: "roman@example.com",
      password: "hamburger01",
      role: 2
    )

    @merchant_1 = create(:random_merchant)
    @merchant_2 = create(:random_merchant)
    @merchant_3 = create(:random_merchant)
    @merchant_4 = create(:random_merchant)

    @item = create(:random_item, merchant_id: @merchant_1.id, active?: false)
    @item_2 = create(:random_item, merchant_id: @merchant_2.id)



    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end
  it "does not allow me to certain pages" do

    expect(@admin_user.role).to eq('admin')

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
  it "can disable merchants" do
    visit '/admin/merchants'

    within "#merchant-#{@merchant_1.id}" do
      expect(page).to have_button("Disable")
    end

    within "#merchant-#{@merchant_2.id}" do
      expect(page).to have_button("Disable")
    end

    within "#merchant-#{@merchant_3.id}" do
      expect(page).to have_button("Disable")
    end

    within "#merchant-#{@merchant_4.id}" do
      expect(page).to have_button("Disable")
      click_link("Disable")
    end

    expect(current_path).to eq("/admin/merchants")

    expect(page).to have_content("#{@merchant_4.name} has been disabled.")

    within "#merchant-#{@merchant_4.id}" do
      expect(page).to_not have_button("Disable")
    end
  end
  it "Can enable a disabled merchant " do
    visit '/admin/merchants'

    within "#merchant-#{@merchant_4.id}" do
      expect(page).to have_button("Disable")
      click_link("Disable")
    end

    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@merchant_4.name} has been disabled.")

    within "#merchant-#{@merchant_4.id}" do
      click_button "Enable Merchant"
    end

    @merchant_4.reload

    within "#merchant-#{@merchant_4.id}" do
      expect(page).to_not have_button "Enable Merchant"
      expect(page).to have_button "Disable Merchant"
    end

    expect(@merchant_4.enabled?).to be_truthy
    expect(page).to have_content("You have enabled #{@merchant_4.name}")
  end
  it "enables a merchant's items if merchant is enabled" do

    visit "/admin/merchants"

    within "#merchant-#{@merchant_4.id}" do
      expect(page).to have_button("Disable")
      click_link("Disable")
    end

    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@merchant_4.name} has been disabled.")

    @merchant_4.reload
    @item.reload
    @item_2.reload
    expect(@item.active?).to eq(false)
    expect(@item1.active?).to eq(false)
    within "#merchant-#{merchant.id}" do
      click_button "Enable Merchant"
    end
    @merchant_4.reload
    @item.reload
    @item_2.reload

    visit "/items"

    expect(page).to have_content(item_2.name)
    expect(page).to have_content(item.name)

    expect(item.active?).to eq(true)
    expect(item_2.active?).to eq(true)
  end
end
