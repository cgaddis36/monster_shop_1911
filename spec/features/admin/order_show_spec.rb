require 'rails_helper'

RSpec.describe "admin orders show page", type: :feature do
  it "has a link from the admin dashboard to an orders show page" do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    default_user = User.create!(name: "Bert",
                                street_address: "123 Sesame St.",
                                city: "NYC",
                                state: "New York",
                                zip_code: 10001,
                                email: "erniesroomie@example.com",
                                password: "paperclips800",
                                role: 0)
    admin_user = User.create!(name: "Ernie",
                                street_address: "123 Sesame St.",
                                city: "NYC",
                                state: "New York",
                                zip_code: 10001,
                                email: "bertie@example.com",
                                password: "bertso",
                                role: 2)

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    click_on("Login")

    fill_in :email, with: default_user.email
    fill_in :password, with: default_user.password

    click_on("Log In")

    click_on("Cart")

    click_on("Checkout")

    fill_in :name, with: default_user.name
    fill_in :address, with: default_user.street_address
    fill_in :city, with: default_user.city
    fill_in :state, with: default_user.state
    fill_in :zip, with: default_user.zip_code

    click_on("Create Order")

    click_on("Log Out")

    click_on("Login")

    fill_in :email, with: admin_user.email
    fill_in :password, with: admin_user.password

    click_on("Log In")

    order = Order.last

    click_on(order.id)

    expect(current_path).to eq("/admin/users/#{default_user.id}/orders/#{order.id}")
  end
end
