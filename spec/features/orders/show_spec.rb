require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do 

  describe 'When I visit my Profile Orders page' do 

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @item1 = create(:random_item, merchant: @mike)
      @item2 = create(:random_item, merchant: @mike)
      @item3 = create(:random_item, merchant: @mike)
      @item4 = create(:random_item, merchant: @mike)
      @item5 = create(:random_item, merchant: @meg)
      @item6 = create(:random_item, merchant: @meg)
      @item7 = create(:random_item, merchant: @meg)
      @item8 = create(:random_item, merchant: @meg)

      visit "/"

      click_on "Register"

      @username = "Johnny"
      @street_address = "123 Jonny Way"
      @city = "Johnsonville"
      @state = "TN"
      @zip_code = "12345"
      @email = "roman@example.com"
      @password = "hamburger01"

      fill_in :name, with: @username
      fill_in :street_address, with: @street_address
      fill_in :city, with: @city
      fill_in :state, with: @state
      fill_in :zip_code, with: @zip_code
      fill_in :email, with: @email
      fill_in :password, with: @password
      fill_in :password_confirmation, with: @password

      click_on "Create User"

      visit "/items/#{@item1.id}"
      click_on "Add To Cart"
      visit "/items/#{@item1.id}"
      click_on "Add To Cart"
      visit "/items/#{@item2.id}"
      click_on "Add To Cart"
      visit "/items/#{@item3.id}"
      click_on "Add To Cart"
    end

    it "the order's show page show all the order's information" do 

      visit "/cart"

      click_on "Checkout"

      fill_in :name, with: @username
      fill_in :address, with: @street_address
      fill_in :city, with: @city
      fill_in :state, with: @state
      fill_in :zip, with: @zip_code.to_i

      click_button "Create Order"

      order1 = Order.last

      visit "/items/#{@item3.id}"
      click_on "Add To Cart"
      visit "/items/#{@item4.id}"
      click_on "Add To Cart"
      visit "/items/#{@item5.id}"
      click_on "Add To Cart"

      visit "/cart"

      click_on "Checkout"

      fill_in :name, with: @username
      fill_in :address, with: @street_address
      fill_in :city, with: @city
      fill_in :state, with: @state
      fill_in :zip, with: @zip_code.to_i

      click_button "Create Order"
      
      order2 = Order.last
      
      visit "/profile/orders"

      click_on order1.id 

      expect(page).to have_content("Order id# = #{order1.id}")
      expect(page).to have_content("Order made on: #{order1.created_at}")
      expect(page).to have_content("Order updated on: #{order1.updated_at}")
      expect(page).to have_content("Current status: #{order1.status}")

      expect(page).to have_content(order1.name)
      expect(page).to have_content(order1.address)
      expect(page).to have_content(order1.city)
      expect(page).to have_content(order1.state)
      expect(page).to have_content(order1.zip)

      within("section#item-#{@item1.id}") do 
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item1.description)
        expect(page).to have_content(2)
        expect(page).to have_content("#{ActiveSupport::NumberHelper.number_to_currency(@item1.price)}")
        expect(page).to have_content("#{ActiveSupport::NumberHelper.number_to_currency(@item1.price * 2)}")
      end

      within("section#item-#{@item2.id}") do 
        expect(page).to have_content(@item2.name)
        expect(page).to have_content(@item2.description)
        expect(page).to have_content(1)
        expect(page).to have_content("#{ActiveSupport::NumberHelper.number_to_currency(@item2.price)}")
        expect(page).to have_content("#{ActiveSupport::NumberHelper.number_to_currency(@item2.price)}")
      end

      expect(page).to have_content("Total Quantity: #{order1.total_quantity}")
      expect(page).to have_content("Total: #{ActiveSupport::NumberHelper.number_to_currency(order1.grandtotal)}")

      expect(page).to_not have_content("Order id# = #{order2.id}")

      expect(page).to_not have_content(@item4.name)
      expect(page).to_not have_content(@item4.description)

    end

  end

end