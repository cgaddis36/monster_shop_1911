require 'rails_helper'

RSpec.describe 'Merchant can see links to CRUD coupons' do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:random_user, role: 1)
    @merchant.users << @merchant_user
    @coupon = @merchant.coupons.create!(name: 'Travis', value: 20, item_quantity: 10)
  end
  describe 'Merchant can see coupons' do
    it 'can see link to view coupons and coupon info on coupon index page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content('Travis')
    end
    it 'can show more coupon info' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{@coupon.id}" do
        click_on 'View Coupon'
      end
      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}")
      expect(page).to have_content(@coupon.name)
      expect(page).to have_content(@coupon.value)
      expect(page).to have_content(@coupon.item_quantity)
    end
    it 'can create new coupon' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      click_on 'Create New Coupon'
      expect(current_path).to eq('/merchant/coupons/new')
      fill_in :name, with: 'Coupon woot woot'
      fill_in :value, with: 20
      fill_in :item_quantity, with: 10
      click_on 'Submit'
      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content('Coupon has been created!')
      expect(page).to have_content('Coupon woot woot')
    end
    it 'will render if bad params are entered' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      click_on 'Create New Coupon'
      expect(current_path).to eq('/merchant/coupons/new')
      fill_in :name, with: ''
      fill_in :value, with: 20
      fill_in :item_quantity, with: 10
      click_on 'Submit'
      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq("/merchant/coupons")
    end
    it 'will shows link to edit coupon' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      within "#coupon-#{@coupon.id}" do
        click_on 'View Coupon'
      end
      click_on 'Edit'
      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")
      fill_in :name, with: 'Travis new coupon'
      fill_in :value, with: 15
      fill_in :item_quantity, with: 20
      click_on 'Submit'
      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}")
      expect(page).to have_content('Coupon Updated')
      expect(page).to have_content('Travis new coupon')
      expect(page).to have_content(15)
      expect(page).to have_content(20)
    end
    it 'will only delete coupon if not used on an order' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      coupon2 = mike.coupons.create(name:'mike test coupon', value: 20, item_quantity: 2)
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

      visit "/items/#{pencil.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"
      visit "/cart"

      click_on "Checkout"
      expect(current_path).to eq("/orders/new")

      fill_in :name, with: username
      fill_in :address, with: street_address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip_code.to_i

      click_button "Create Order"
      click_on 'Log Out'
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      visit '/merchant'
      click_on 'See Coupons'
      within "#coupon-#{coupon2.id}" do
        click_on 'View Coupon'
      end
      click_on 'Delete'
      expect(page).to have_content("#{coupon2.name} has been used in an order")
      expect(current_path).to eq("/merchant/coupons/#{coupon2.id}")
      visit '/merchant'
      click_on 'See Coupons'
      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{@coupon.id}" do
        click_on 'View Coupon'
      end
      expect(current_path).to eq("/merchant/coupons/#{@coupon.id}")
      click_on 'Delete'
      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content("Coupon has been deleted")
      expect(page).to have_content("#{coupon2.name}")
      expect(page).to_not have_content("#{@coupon.name}")
    end
  end
end
