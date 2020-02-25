require 'rails_helper'

RSpec.describe "Merchant order show page", type: :feature do
  before(:each) do
    @merchant = create(:random_merchant)
    @merchant_2 = create(:random_merchant)


    @item_1 = create(:random_item, merchant_id: @merchant.id)
    @item_2 = create(:random_item, merchant_id: @merchant.id)
    @item_3 = create(:random_item, merchant_id: @merchant.id)
    @item_4 = create(:random_item, merchant_id: @merchant.id)
    @item_5 = create(:random_item, merchant_id: @merchant.id)
    @item_6 = create(:random_item, merchant_id: @merchant_2.id)
    @item_7 = create(:random_item, merchant_id: @merchant_2.id)

    @bill = @merchant.users.create(name: "Billy",
                                   street_address: "123 Bilbo Baggins Ave",
                                   city: "Rockville",
                                   state: "TN",
                                   zip_code: 34566,
                                   email: "billybob@example.com",
                                   password: "MynameisBill3",
                                   role: 1
                                   )

    @user = create(:random_user, role: 0)
  end
  it "I see order usr attributes and items from my store in the order" do

    visit '/login'

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password

    click_on 'Log In'

    click_on("All Items")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_2.name)
    click_on("Add To Cart")

    click_on(@item_3.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_5.name)
    click_on("Add To Cart")

    click_on(@item_6.name)
    click_on("Add To Cart")

    click_on(@item_7.name)
    click_on("Add To Cart")

    click_on("Cart")

    click_on("Checkout")

    fill_in 'name', with: @user.name
    fill_in 'address', with: @user.street_address
    fill_in 'city', with: @user.city
    fill_in 'state', with: @user.state
    fill_in 'zip', with: @user.zip_code

    click_on("Create Order")

    click_on("Log Out")

    click_on("Login")

    fill_in 'email', with: @bill.email
    fill_in 'password', with: @bill.password

    click_on 'Log In'

    order = Order.last

    click_on(order.id)

    require "pry"; binding.pry


    save_and_open_page
    # require "pry"; binding.pry
 end
end
# As a merchant employee
# When I visit an order show page from my dashboard
# I see the recipients name and address that was used to create this order
# I only see the items in the order that are being purchased from my merchant
# I do not see any items in the order being purchased from other merchants
# For each item, I see the following information:
# - the name of the item, which is a link to my item's show page
# - an image of the item
# - my price for the item
# - the quantity the user wants to purchase
