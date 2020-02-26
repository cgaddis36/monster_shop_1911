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
    it "I see order user attributes and items from my store in the order" do

    visit '/login'

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password

    click_on 'Log In'

    click_on("All Items")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_2.name)
    click_on("Add To Cart")

    click_on(@item_3.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
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

    expect(page).to have_content(order.name)
    expect(page).to have_content(order.address)
    expect(page).to have_content(order.city)
    expect(page).to have_content(order.state)
    expect(page).to have_content(order.zip)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.image)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content("Number of Items: 2")
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.image)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content("Number of Items: 1")
    end

    within "#item-#{@item_3.id}" do
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@item_3.image)
      expect(page).to have_content(@item_3.price)
      expect(page).to have_content("Number of Items: 1")
    end

    within "#item-#{@item_4.id}" do
      expect(page).to have_content(@item_4.name)
      expect(page).to have_content(@item_4.image)
      expect(page).to have_content(@item_4.price)
      expect(page).to have_content("Number of Items: 2")
    end

    within "#item-#{@item_5.id}" do
      expect(page).to have_content(@item_5.name)
      expect(page).to have_content(@item_5.image)
      expect(page).to have_content(@item_5.price)
      expect(page).to have_content("Number of Items: 1")
    end

    within "#item-#{@item_6.id}" do
      expect(page).to_not have_content(@item_6.name)
      expect(page).to_not have_content(@item_6.image)
      expect(page).to_not have_content(@item_6.price)
      expect(page).to_not have_content("Number of Items: 1")
    end

    within "#item-#{@item_7.id}" do
      expect(page).to_not have_content(@item_7.name)
      expect(page).to_not have_content(@item_7.image)
      expect(page).to_not have_content(@item_7.price)
      expect(page).to_not have_content("Number of Items: 1")
    end
  end
end
