require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do

      @default_user = User.create!(name: "Bert",
                                  street_address: "123 Sesame St.",
                                  city: "NYC",
                                  state: "New York",
                                  zip_code: 10001,
                                  email: "erniesroomie@example.com",
                                  password: "paperclips800",
                                  role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end

    it "I need to log in or register to be able to checkout" do
      
      visit "/cart"
      
      expect(page).to have_content("You must register or log in to finish the checkout process")

      click_on "register"

      expect(current_path).to eq("/register")

      visit "/cart"

      click_on "log in"

      expect(current_path).to eq("/login")

    end

    it "allows a user to place an order and the order is associated with this user" do

      visit "/items"

      click_on "Register"

      expect(current_path).to eq("/register")

      username = "Johnny"
      street_address = "123 Jonny Way"
      city = "Johnsonville"
      state = "TN"
      zip_code = "12345"
      email = "roman@example.com"
      password = "hamburger01"

      fill_in :name, with: username
      fill_in :street_address, with: street_address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip_code, with: zip_code
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password

      click_on "Create User"

      visit "/cart"

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")

      fill_in :name, with: username
      fill_in :address, with: street_address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip_code.to_i

      click_button "Create Order"

      expect(Order.last.name).to eq(username)
      expect(Order.last.address).to eq(street_address)
      expect(Order.last.city).to eq(city)
      expect(Order.last.state).to eq(state)
      expect(Order.last.zip).to eq(zip_code.to_i)
      expect(Order.last.pending?).to eq(true)
      expect(Order.last.user).to eq(User.last)

      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("You order was created")
      
      within("div#order_#{Order.last.id}") do 
       expect(page).to have_content("Order id# = #{Order.last.id}")
      end

      within("nav") do
        expect(page).to have_content("Cart: 0")
      end

    end
  end
  
# User Story 26, Registered users can check out

# As a registered user
# When I add items to my cart
# And I visit my cart
# I see a button or link indicating that I can check out
# And I click the button or link to check out and fill out order info and click create order
# An order is created in the system, which has a status of "pending"
# That order is associated with my user
# I am taken to my orders page ("/profile/orders")
# I see a flash message telling me my order was created
# I see my new order listed on my profile orders page
# My cart is now empty




  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end


end
