# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant delete items', type: :feature do

  describe 'As a merchant employee' do

    describe 'When I visit my items page' do

      before(:each) do
        @merchant_user = User.create!(name: 'Alejandro',
                                      street_address: '321 Jones Dr',
                                      city: 'Jonesville',
                                      state: 'WI',
                                      zip_code: 54_321,
                                      email: 'alejandro@example.com',
                                      password: 'hamburger3',
                                      role: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

        @merchant = create(:random_merchant)
        @merchant.users << @merchant_user

        @item1 = create(:random_item, merchant: @merchant)
        @item2 = create(:random_item, merchant: @merchant)
        @item3 = create(:random_item, merchant: @merchant)

        user = create(:random_user, role: 0)
        order = create(:random_order, user: user)

        ItemOrder.create!(item: @item2, order: order, price: @item2.price, quantity: 5)
      end

      it 'it has a link to delete items that have not been ordered' do

        visit '/merchant/items'

        within("section#item-#{@item1.id}") do
          expect(page).to have_content(@item1.name)
          expect(page).to have_link('Delete')
        end

        within("section#item-#{@item2.id}") do
          expect(page).to have_content(@item2.name)
          expect(page).to_not have_link('Delete')
        end

        within("section#item-#{@item3.id}") do
          expect(page).to have_content(@item3.name)
          expect(page).to have_link('Delete')
        end

        deleted_item_name = @item1.name

        within("section#item-#{@item1.id}") do
          click_link('Delete')
        end

        expect(current_path).to eq('/merchant/items')
        expect(page).to_not have_link(deleted_item_name)
        expect(page).to have_content(deleted_item_name + ' has been deleted')
        
      end
    end
  end
end
