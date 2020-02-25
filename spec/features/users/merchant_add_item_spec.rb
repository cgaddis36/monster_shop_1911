require 'rails_helper'

RSpec.describe 'Merchant add items', type: :feature do
  describe 'As a merchant employee' do
    describe 'When I visit my items page' do
      before(:each) do
        @merchant_user = User.create!(name: 'Alejandro',
                                      street_address: '321 Jones Dr',
                                      city: 'Jonesville',
                                      state: 'WI',
                                      zip_code: 54_321,
                                      email: 'alejandro@example.com',
                                      password: 'hamburger3',
                                      role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

        @merchant = create(:random_merchant)
        @merchant.users << @merchant_user

        @item1 = create(:random_item, merchant: @merchant)
        @item2 = create(:random_item, merchant: @merchant)
        @item3 = create(:random_item, merchant: @merchant)

        user = create(:random_user, role: 0)
        order = create(:random_order, user: user)

        ItemOrder.create!(item: @item2, order: order, price: @item2.price, quantity: 5)
  
      end

      it 'I can click on a link to create a new item and fill out the item information in a form' do

        visit '/merchant/items'

        click_link("Add New Item")
  
        expect(current_path).to eq("/merchant/items/new")

        name = "Pair of boots"
        price = 65
        description = "Don't fear the rain!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25
        fill_in :_merchant_items_name, with: name
        fill_in :_merchant_items_price, with: price
        fill_in :_merchant_items_description, with: description
        fill_in :_merchant_items_image, with: image_url
        fill_in :_merchant_items_inventory, with: inventory

        click_button "Create Item"
        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content('Your new item was saved')
        new_item = Item.last
        item_active = Item.last.active?

        expect(new_item.name).to eq(name)
        expect(new_item.price).to eq(price)
        expect(new_item.description).to eq(description)
        expect(new_item.image).to eq(image_url)
        expect(new_item.inventory).to eq(inventory)

        expect(item_active).to be(true)

        within("section#item-#{new_item.id}") do
          expect(page).to have_content(name)
          expect(page).to have_content("Price: $#{new_item.price}")
          expect(page).to have_css("img[src*='#{new_item.image}']")
          expect(page).to have_content("Active")
          expect(page).to_not have_content(new_item.description)
          expect(page).to have_content("Inventory: #{new_item.inventory}")
        end

      end


      it 'I can only create a new item if the required fields are entered' do

        visit '/merchant/items'

        click_link("Add New Item")
  
        save_and_open_page
  
        latest_item_created = Item.last

        name = ""
        price = 0
        description = ""
        image_url = ""
        inventory = -5
        fill_in :_merchant_items_name, with: name
        fill_in :_merchant_items_price, with: price
        fill_in :_merchant_items_description, with: description
        fill_in :_merchant_items_image, with: image_url
        fill_in :_merchant_items_inventory, with: inventory

        click_button "Create Item"

        expect(current_path).to eq("/merchant/items/new")
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price must be greater than 0")
        expect(page).to have_content("Inventory must be greater than or equal to 0")
        expect(page).to_not have_content("Image can't be blank")


        expect(Item.last).to eq(latest_item_created)
      end

      it 'I can see a default image if no image was entered' do

        visit '/merchant/items'

        click_link("Add New Item")
  

        name = "Pair of boots"
        price = 65
        description = "Don't fear the rain!"
        image_url = ""
        inventory = 25
        fill_in :_merchant_items_name, with: name
        fill_in :_merchant_items_price, with: price
        fill_in :_merchant_items_description, with: description
        fill_in :_merchant_items_image, with: image_url
        fill_in :_merchant_items_inventory, with: inventory

        click_button "Create Item"

        new_item = Item.last

        within("section#item-#{new_item.id}") do
          expect(page).to have_content(name)
          expect(page).to have_content("Price: $#{new_item.price}")
          expect(page).to have_css("img[src*='#{"https://t3.ftcdn.net/jpg/02/48/42/64/240_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg"}']")
          expect(page).to have_content("Active")
          expect(page).to_not have_content(new_item.description)
          expect(page).to have_content("Inventory: #{new_item.inventory}")
        end
        
      end

  end
end
end