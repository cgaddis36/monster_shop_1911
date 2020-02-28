# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As any user', type: :feature do
  before(:each) do
    @default_user = User.create!(name: 'Johnny',
                                 street_address: '123 Jonny Way',
                                 city: 'Johnsonville',
                                 state: 'TN',
                                 zip_code: 12_345,
                                 email: 'roman@example.com',
                                 password: 'hamburger01',
                                 role: 0)
    @merchant_user = User.create!(name: 'Alejandro',
                                  street_address: '321 Jones Dr',
                                  city: 'Jonesville',
                                  state: 'WI',
                                  zip_code: 54_321,
                                  email: 'alejandro@example.com',
                                  password: 'hamburger3',
                                  role: 1)
    @admin_user = User.create!(name: 'Kyle',
                               street_address: '1243 Kyle Way',
                               city: 'Kylesville',
                               state: 'TX',
                               zip_code: 12_345,
                               email: 'kyle@example.com',
                               password: 'hamburger04',
                               role: 2)

    @merchant = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @item_1 = @merchant.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @item_2 = @merchant.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
    @item_3 = @merchant.items.create(name: 'Shimano Shifters', description: "It'll always shift!", price: 180, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 2)
    @item_4 = @merchant.items.create(name: 'Boots', description: "Dont fear the rain!", price: 129, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 6)
    @item_5 = @merchant.items.create(name: 'Bike Lights', description: "Dont fear the dark!", price: 62, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
    @item_6 = @merchant.items.create(name: 'Camelback water bottle', description: "Dont fear the thirst!", price: 42, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
    @item_7 = @merchant.items.create(name: 'Helmet', description: "Dont fear the risk!", price: 20, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 15)

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

    item_order1_info = { order_id: @order1.id, item_id: @item_1.id, price: @item_1.price, quantity: 34 }
    item_order1 = ItemOrder.create!(item_order1_info)

    item_order2_info = { order_id: @order2.id, item_id: @item_2.id, price: @item_2.price, quantity: 20 }
    item_order2 = ItemOrder.create!(item_order2_info)

    item_order3_info = { order_id: @order1.id, item_id: @item_3.id, price: @item_3.price, quantity: 100 }
    item_order3 = ItemOrder.create!(item_order3_info)

    item_order4_info = { order_id: @order2.id, item_id: @item_4.id, price: @item_4.price, quantity: 27 }
    item_order4 = ItemOrder.create!(item_order4_info)

    item_order5_info = { order_id: @order1.id, item_id: @item_5.id, price: @item_5.price, quantity: 56 }
    item_order5 = ItemOrder.create!(item_order5_info)

    item_order6_info = { order_id: @order2.id, item_id: @item_6.id, price: @item_6.price, quantity: 23 }
    item_order6 = ItemOrder.create!(item_order6_info)

    item_order7_info = {order_id: @order1.id, item_id: @item_7.id, price: @item_7.price, quantity: 54 }
    item_order7 = ItemOrder.create!(item_order7_info)

    item_order8_info = {order_id: @order2.id, item_id: @item_1.id, price: @item_1.price, quantity: 35 }
    item_order8 = ItemOrder.create!(item_order8_info)

  end

  it 'the items index page shows all the statistics for a default user' do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

    visit '/items'

    most_popular_items = "the most popular items are :\nShimano Shifters, 100\nGatorskins, 69\nBike Lights, 56\nHelmet, 54\nBoots, 27"
    expect(page).to have_content(most_popular_items)
    least_popular_items = "the least popular items are :\nChain, 20\nCamelback water bottle, 23\nBoots, 27\nHelmet, 54\nBike Lights, 56"
    expect(page).to have_content(least_popular_items)
  end

  it 'the items index page shows all the statistics for a merchant user' do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    visit '/items'

    most_popular_items = "the most popular items are :\nShimano Shifters, 100\nGatorskins, 69\nBike Lights, 56\nHelmet, 54\nBoots, 27"
    expect(page).to have_content(most_popular_items)
    least_popular_items = "the least popular items are :\nChain, 20\nCamelback water bottle, 23\nBoots, 27\nHelmet, 54\nBike Lights, 56"
    expect(page).to have_content(least_popular_items)
  end

  it 'the items index page shows all the statistics for an admin user' do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)

    visit '/items'
    most_popular_items = "the most popular items are :\nShimano Shifters, 100\nGatorskins, 69\nBike Lights, 56\nHelmet, 54\nBoots, 27"
    expect(page).to have_content(most_popular_items)
    least_popular_items = "the least popular items are :\nChain, 20\nCamelback water bottle, 23\nBoots, 27\nHelmet, 54\nBike Lights, 56"
    expect(page).to have_content(least_popular_items)

  end
end
