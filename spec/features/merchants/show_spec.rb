require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end
    describe 'as a merchant employee' do
      it 'has button to deactive an item next to each item' do

       merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 1)

       item_1 = create(:random_item, merchant_id: @bike_shop.id)
       item_2 = create(:random_item, merchant_id: @bike_shop.id)
       item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
       @bike_shop.users << merchant_user

       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

       visit '/merchant/items'

       within "#item-#{item_1.id}" do
         expect(page).to have_button("Deactivate")
       end

       within "#item-#{item_3.id}" do
         expect(page).to_not have_button("Deactivate")
       end

       within "#item-#{item_2.id}" do
         click_button "Deactivate"
       end

       expect(current_path).to eq("/merchant/items")
       expect(page).to have_content("#{item_2.name} is deactivated")
       item_1.reload
       item_2.reload
       item_3.reload
       expect(item_1.active?).to eq(true)
       expect(item_2.active?).to eq(false)
       expect(item_3.active?).to eq(false)
     end
     it 'can activate a deactivated item' do
       merchant_user = create(:random_user, merchant_id: @bike_shop.id, role: 1)

       item_1 = create(:random_item, merchant_id: @bike_shop.id)
       item_2 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
       item_3 = create(:random_item, merchant_id: @bike_shop.id, active?: false)
       @bike_shop.users << merchant_user

       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

       visit '/merchant/items'

       within "#item-#{item_1.id}" do
         expect(page).not_to have_button("Activate")
       end

       within "#item-#{item_2.id}" do
         expect(page).to have_button("Activate")
       end

       within "#item-#{item_3.id}" do
         click_button("Activate")
       end

       expect(current_path).to eq("/merchant/items")
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
end
