require 'rails_helper'

RSpec.describe 'Merchant can see links to CRUD coupons' do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:random_user, role: 1)
    @merchant.users << @merchant_user
    @coupon = @merchant.coupons.create!(name: 'Travis', value: 20, item_quantity: 10)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end
  describe 'Merchant can see coupons' do
    it 'can see link to view coupons and coupon info on coupon index page' do
      visit '/merchant'
      click_on 'See Coupons'
      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content('Travis')
    end
    it 'can show more coupon info' do
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
  end
end
