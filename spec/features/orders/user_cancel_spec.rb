require 'rails_helper'

RSpec.describe "Merchant order fulfillment page", type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @pull_toy = @dog_shop.items.create(name: "Pully Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @tire = @bike_shop.items.create(name: "GatorSkins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @dog_bone = @dog_shop.items.create(name: "Doggy Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    @merchant_user1 = @bike_shop.users.create!(name: "Johnny",
                                street_address: "123 Jonny Way",
                                city: "Johnsonville",
                                state: 'TN',
                                zip_code: 12345,
                                email: "roman4444@example.com",
                                password: "hamburger042",
                                role: 1
                              )

    @merchant_user2 = @dog_shop.users.create!(name: "Jeremiah",
                                street_address: "7777 Rastafari Way",
                                city: "Jamaica",
                                state: 'FL',
                                zip_code: 46766,
                                email: "ziggymarley@example.com",
                                password: "irie333",
                                role: 1
                              )

    @walter = User.create!(name: "Walter White",
                                 street_address: "6230 Bluerock Ln",
                                 city: "Albuquerque",
                                 state: 'NM',
                                 zip_code: 44565,
                                 email: "heisenberg@example.com",
                                 password: "method3",
                                 role: 0
                                  )
  end
  it "all merchants can fulfill items on an order" do
    visit '/login'

    fill_in 'email', with: @walter.email
    fill_in 'password', with: @walter.password

    click_on 'Log In'

    click_on("All Items")

    click_on("GatorSkins")
    click_on("Add To Cart")

    click_on("Doggy Bone")
    click_on("Add To Cart")

    click_on("Pully Toy")
    click_on("Add To Cart")

    click_on("Pully Toy")
    click_on("Add To Cart")

    visit "/cart"

    click_on("Checkout")

    fill_in :name, with: @walter.name
    fill_in :address, with: @walter.street_address
    fill_in :city, with: @walter.city
    fill_in :state, with: @walter.state
    fill_in :zip, with: @walter.zip_code

    click_button("Create Order")

    order = Order.last

    visit '/profile/orders'

    click_on(order.id)
    click_on("Cancel Order")

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Your order has been cancelled.")

    click_on("My Orders")

    within "#order_#{order.id}"do
      expect(page).to have_content("Current status: cancelled")
    end
  end

  it "when an order has items that have been fulfilled and that order is cancelled, those items inventories are returned" do


    visit '/login'

    fill_in 'email', with: @walter.email
    fill_in 'password', with: @walter.password

    click_on 'Log In'

    click_on("All Items")

    click_on("GatorSkins")
    click_on("Add To Cart")

    click_on("Doggy Bone")
    click_on("Add To Cart")

    click_on("Pully Toy")
    click_on("Add To Cart")

    click_on("Pully Toy")
    click_on("Add To Cart")

    visit "/cart"

    click_on("Checkout")

    fill_in :name, with: @walter.name
    fill_in :address, with: @walter.street_address
    fill_in :city, with: @walter.city
    fill_in :state, with: @walter.state
    fill_in :zip, with: @walter.zip_code

    click_button("Create Order")

    order = Order.last

    order.item_orders.last.update(status: "fulfilled")

    visit '/profile/orders'

    click_on(order.id)

    expect(ItemOrder.last.quantity).to eq(2)
    expect(Item.first.inventory).to eq(32)

    click_on("Cancel Order")

    expect(Item.first.inventory).to eq(34)

    expect(order.item_orders.first.status).to eq("unfulfilled")
    expect(order.item_orders[1].status).to eq("unfulfilled")
    expect(order.item_orders[2].status).to eq("unfulfilled")
    expect(order.item_orders.last.status).to eq("unfulfilled")

    expect(page).to_not have_link("Cancel Order")
  end
end
