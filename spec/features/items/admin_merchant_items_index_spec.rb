require 'rails_helper'

  RSpec.describe 'As an admin' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end
    describe 'I can act as a merchant employee' do
    it 'has button to deactive an item next to each item' do

     admin_user = create(:random_user, role: 2)

     item_1 = create(:random_item, merchant_id: @bike_shop.id)
     item_2 = create(:random_item, merchant_id: @bike_shop.id)
     item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

     visit "/admin/merchants"
     click_link(@bike_shop.name)
     expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")

     within "#merchant-#{@bike_shop.id}" do
       click_on("Merchant Items")
     end

     expect(current_path).to eq("/admin/merchants/items")
     within "#item-#{item_1.id}" do
       expect(page).to have_button("Deactivate")
     end

     within "#item-#{item_3.id}" do
       expect(page).to_not have_button("Deactivate")
     end

     within "#item-#{item_2.id}" do
       click_button "Deactivate"
     end

     expect(current_path).to eq("/admin/merchants/items")
     expect(page).to have_content("#{item_2.name} is deactivated")
     item_1.reload
     item_2.reload
     item_3.reload
     expect(item_1.active?).to eq(true)
     expect(item_2.active?).to eq(false)
     expect(item_3.active?).to eq(false)
    end
    it 'can activate a deactivated item' do
     admin_user = create(:random_user, role: 2)

     item_1 = create(:random_item, merchant_id: @bike_shop.id)
     item_2 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
     item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

     visit "/admin/merchants/items"

     within "#item-#{item_1.id}" do
       expect(page).not_to have_button("Activate")
     end

     within "#item-#{item_2.id}" do
       expect(page).to have_button("Activate")
     end

     within "#item-#{item_3.id}" do
       click_button("Activate")
     end

     expect(current_path).to eq("/admin/merchant/items")
     expect(page).to have_content("#{item_3.name} is activated")
     item_1.reload
     item_2.reload
     item_3.reload
     expect(item_1.active?).to eq(true)
     expect(item_2.active?).to eq(false)
     expect(item_3.active?).to eq(true)
    end
  end
end
