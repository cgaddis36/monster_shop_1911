require 'rails_helper'
RSpec.describe "As a merchant employee", type: :feature do 

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

    it 'I can click the edit link next to any item to edit its information' do 

      visit '/merchant/items'

      within("section#item-#{@item3.id}") do
        click_link("Edit Item")
      end

      original_status = @item3.active?
    
      expect(current_path).to eq("/merchant/items/#{@item3.id}/edit")

      expect(find_field('Name').value).to eq @item3.name
      expect(find_field('Price').value).to eq @item3.price.to_s
      expect(find_field('Description').value).to eq @item3.description
      expect(find_field('Image').value).to eq @item3.image
      expect(find_field('Inventory').value).to eq @item3.inventory.to_s

      name = "Monopoly Socialism"
      price = 65
      description = "Winning is for capitalists!"
      image_url = "https://cnet3.cbsistatic.com/img/4fzJn1AahvNPlyOsCVNriTnWGGc=/1092x0/2019/08/23/a67d6101-8709-4ca5-ad29-08e3609b8899/106092553-1566505356068monopoly.jpg"
      inventory = 25

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items")

      expect(page).to have_content("Your item was updated successfully")

      within("section#item-#{@item3.id}") do
        expect(page).to have_content(name)
        expect(page).to have_content("Price: $#{price}")
        expect(page).to have_css("img[src*='#{image_url}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(description)
        expect(page).to have_content("Inventory: #{inventory}")
      end

      new_status = @item3.active?

      expect(new_status).to eq(original_status)

    end

    it 'if I leave the image url blank when editing an item, I see a placeholder image' do 

      visit '/merchant/items'

      within("section#item-#{@item3.id}") do
        click_link("Edit Item")
      end

      original_status = @item3.active?
    
      expect(current_path).to eq("/merchant/items/#{@item3.id}/edit")

      expect(find_field('Name').value).to eq @item3.name
      expect(find_field('Price').value).to eq @item3.price.to_s
      expect(find_field('Description').value).to eq @item3.description
      expect(find_field('Image').value).to eq @item3.image
      expect(find_field('Inventory').value).to eq @item3.inventory.to_s

      name = "Monopoly Socialism"
      price = 65
      description = "Winning is for capitalists!"
      image_url = ""
      inventory = 25

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items")

      within("section#item-#{@item3.id}") do
        expect(page).to have_content(name)
        expect(page).to have_content("Price: $#{price}")
        expect(page).to have_css("img[src*='#{"https://t3.ftcdn.net/jpg/02/48/42/64/240_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg"}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(description)
        expect(page).to have_content("Inventory: #{inventory}")
      end
    
    end

    it 'if I fill out the edit form incorrectly, I see a flash message and I am redirected to the edit page' do 

      visit '/merchant/items'

      within("section#item-#{@item3.id}") do
        click_link("Edit Item")
      end

      original_status = @item3.active?
    
      expect(current_path).to eq("/merchant/items/#{@item3.id}/edit")

      expect(find_field('Name').value).to eq @item3.name
      expect(find_field('Price').value).to eq @item3.price.to_s
      expect(find_field('Description').value).to eq @item3.description
      expect(find_field('Image').value).to eq @item3.image
      expect(find_field('Inventory').value).to eq @item3.inventory.to_s

      name = "Monopoly Socialism"
      price = ""
      description = "Winning is for capitalists!"
      image_url = ""
      inventory = 25

      fill_in :item_name, with: name
      fill_in :item_price, with: price
      fill_in :item_description, with: description
      fill_in :item_image, with: image_url
      fill_in :item_inventory, with: inventory

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items/#{@item3.id}/edit")

      expect(find_field('Name').value).to eq @item3.name
      expect(find_field('Price').value).to eq @item3.price.to_s
      expect(find_field('Description').value).to eq @item3.description
      expect(find_field('Image').value).to eq @item3.image
      expect(find_field('Inventory').value).to eq @item3.inventory.to_s  

      expect(page).to have_content("Price can't be blank")
      expect(page).to have_content("Price can't be blank and Price must be greater than 0")
    
    end

  end

end
