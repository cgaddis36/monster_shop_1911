require 'rails_helper'

  describe "As an admin_user" do
    describe "I visit my dashboard" do
      before :each do
        @user1 = create(:random_user)
        @user2 = create(:random_user)
        @user3 = create(:random_user)
        @user4 = create(:random_user)

        @m1 = create(:random_merchant)
        @m2 = create(:random_merchant)
        @m3 = create(:random_merchant)
        @m4 = create(:random_merchant)

        @tire = @m1.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 200)
        @pull_toy = @m2.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 200)
        @dog_bone = @m3.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 200)

        @order1 = @user1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        @order2 = @user2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
        @order3 = @user3.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)
        @order4 = @user4.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)

        @order1.item_orders.create!(item: @tire, price: @tire.price, quantity: 22)
        @order1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 33)
        @order1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 44)

        @order2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 22)
        @order2.item_orders.create!(item: @tire, price: @tire.price, quantity: 33)
        @order2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 44)

        @order3.item_orders.create!(item: @tire, price: @tire.price, quantity: 22)
        @order3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 33)
        @order3.item_orders.create!(item: @tire, price: @tire.price, quantity: 44)

        @order4.item_orders.create!(item: @tire, price: @tire.price, quantity: 3)
        @order4.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 6)
        @order4.item_orders.create!(item: @tire, price: @tire.price, quantity: 9)

        @admin_user = User.create!(name: "Bob T Builder",
                                    street_address: "123 Contractor Blvd.",
                                    city: "Fixit",
                                    state: 'TN',
                                    zip_code: "45678",
                                    email: "yeswecan@example.com",
                                    password: "hammertime7",
                                    role: 2
                                  )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      end

      it "sees all orders in the system and the order's user name links to the admin view of the user" do
        visit "/admin"

         within ".orders" do
          within "#order-#{@order1.id}" do
            expect(page).to have_content("Order ID: #{@order1.id}")
            expect(page).to have_content(@order1.created_at)
            expect(page).to have_link(@order1.user.name)
          end

           within "#order-#{@order2.id}" do
            expect(page).to have_content("Order ID: #{@order2.id}")
            expect(page).to have_content(@order2.created_at)
            expect(page).to have_link(@order2.user.name)
          end

          within "#order-#{@order3.id}" do
            expect(page).to have_content("Order ID: #{@order3.id}")
            expect(page).to have_content(@order3.created_at)
            expect(page).to have_link(@order3.user.name)
          end

          within "#order-#{@order4.id}" do
            expect(page).to have_content("Order ID: #{@order4.id}")
            expect(page).to have_content(@order4.created_at)
            click_link "#{@order4.user.name}"
          end
        end

        expect(current_path).to eq("/admin/users/#{@order4.user.id}")
    end

    it "sorts the orders by order status (packaged, pending, shipped, cancelled)" do
      @order1.status = "packaged"
      @order2.status = "pending"
      @order3.status = "shipped"
      @order4.status = "cancelled"

      binding.pry


    end
  end
end
# Orders are sorted by "status" in this order:
#
# - packaged
# - pending
# - shipped
# - cancelled
