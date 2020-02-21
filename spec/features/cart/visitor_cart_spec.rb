require 'rails_helper'

RSpec.describe "Visitor's cart" do
  describe 'When I have items in my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 5)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
      @pen = @mike.items.create(name: "Red Pen", description: "You can write on paper with it!", price: 1, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
    end

    it "I can increment the amount of an item in my cart, but not more than is in inventory" do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      within "#cart-item-#{@paper.id}" do
        click_button "Add One More"
        click_button "Add One More"
        click_button "Add One More"
        click_button "Add One More"
        expect(page).to have_content("5 of #{@paper.name}")
        click_button "Add One More"
        expect(page).to have_content("5 of #{@paper.name}")
      end
    end

    it "I can decrement the amount of an item in my cart. when cart quantity is zero, item is removed from cart" do
      visit "/items/#{@pen.id}"
      click_on "Add To Cart"

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      within "#cart-item-#{@pen.id}" do
        click_button "Add One More"
        expect(page).to have_content("2 of #{@pen.name}")
        click_button "Remove One From Cart"
        expect(page).to have_content("1 of #{@pen.name}")
        click_button "Remove One From Cart"
      end
      
      expect(page).not_to have_content("#{@pen.name}")
      end
    end
  end
