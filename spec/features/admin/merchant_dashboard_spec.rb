require 'rails_helper'

RSpec.describe "As a merchant employee", type: :feature do

  describe 'when I visit my merchant dashboard' do

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
      @merchant1 = Merchant.create(name: "Meg's Bike Shop!", address: '1234 Bike Rd.', city: 'Dallas', state: 'AL', zip: 54321)
      @merchant2 = Merchant.create(name: "Mike's Print Shop!", address: '1234 Paper Rd.', city: 'Allen', state: 'PA', zip: 12345)

      @item1 = create(:random_item, merchant: @merchant2)
      @item2 = create(:random_item, merchant: @merchant2)
      @item3 = create(:random_item, merchant: @merchant2)
      @item4 = create(:random_item, merchant: @merchant2)

      @merchant2.items << @item1
      @merchant2.items << @item2
      @merchant2.items << @item3
      @merchant2.items << @item4

      @default_user = User.create!(name: 'Johnny',
                                 street_address: '123 Jonny Way',
                                 city: 'Johnsonville',
                                 state: 'TN',
                                 zip_code: 12_345,
                                 email: 'roman1@example.com',
                                 password: 'hamburger01',
                                 role: 0)

      order_info1 = {
                      name: 'Bert',
                      address: '123 Sesame St.',
                      city: 'NYC',
                      state: 'New York',
                      zip: '10001'
                    }

      order_info2 = {
                      name: 'Mark',
                      address: '112 Elm St.',
                      city: 'Cambridge',
                      state: 'MA',
                      zip: '02139'
                    }

      @order1 = @default_user.orders.create!(order_info1)
      @order2 = @default_user.orders.create!(order_info2)

      item_order1_info = { order_id: @order1.id, item_id: @item1.id, price: @item1.price, quantity: 10 }
      item_order1 = ItemOrder.create!(item_order1_info)

      item_order2_info = { order_id: @order2.id, item_id: @item2.id, price: @item2.price, quantity: 12 }
      item_order2 = ItemOrder.create!(item_order2_info)

    end

    it 'has a link to view the merchant items' do

      visit "/login"

      fill_in :email, with: @admin_user.email
      fill_in :password, with: @admin_user.password
      click_on "Log In"

      visit "/admin/merchants"

      within "#merchant-#{@merchant2.id}" do
        click_link(@merchant2.name)
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant2.id}")

      expect(page).to have_content("Mike's Print Shop")
      expect(page).to have_content('1234 Paper Rd.')
      expect(page).to have_content("Allen")
      expect(page).to have_content("PA")
      expect(page).to have_content(12345)
      expect(page).to have_content("Number of Items: #{@merchant2.item_count}")
      expect(page).to have_content("Average Price of Items: #{ActiveSupport::NumberHelper.number_to_currency(@merchant2.average_item_price)}")
      expect(page).to have_link("All #{@merchant2.name} Items")
      expect(page).to have_link("Update Merchant")

      @merchant2.orders.each do |order|
        within("section#pending-#{order.id}") do
          expect(page).to have_content("ID: #{order.id}")
          expect(page).to have_content("Order Created: #{order.created_at}")
          expect(page).to have_content("Quantity of my items in this order: #{order.item_quantity_merchant(@merchant2)}")
          expect(page).to have_content("Value of my items in this order: #{ActiveSupport::NumberHelper.number_to_currency(order.item_total_merchant(@merchant2))}")
        end
      end

      expect(page).to_not have_content("Meg's Bike Shop")
      expect(page).to_not have_content('123 Bike Rd.')
      expect(page).to_not have_content("Denver")
      expect(page).to_not have_content("CO")
      expect(page).to_not have_content(80203)

    end

  end
end
