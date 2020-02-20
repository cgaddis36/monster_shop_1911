require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "most and least popular items" do 

      @merchant = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @item_1 = @merchant.items.create!(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @item_2 = @merchant.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      @item_3 = @merchant.items.create!(name: 'Shimano Shifters', description: "It'll always shift!", price: 180, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 2)
      @item_4 = @merchant.items.create!(name: 'Boots', description: "Dont fear the rain!", price: 129, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 6)
      @item_5 = @merchant.items.create!(name: 'Bike Lights', description: "Dont fear the dark!", price: 62, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
      @item_6 = @merchant.items.create!(name: 'Camelback water bottle', description: "Dont fear the thirst!", price: 42, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
      @item_7 = @merchant.items.create!(name: 'Helmet', description: "Dont fear the risk!", price: 20, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 15)


      order_info1 = {
        name: 'Bert',
        address: '123 Sesame St.',
        city: 'NYC',
        state: 'New York',
        zip: '10001'
      }

      order_info2 = {
        name: 'Mark',
        address: '112 Elm St.',
        city: 'Cambridge',
        state: 'MA',
        zip: '02139'
      }
    
      @order1 = Order.create!(order_info1)
      @order2 = Order.create!(order_info2)
      
      item_order1_info = { order_id: @order1.id, item_id: @item_1.id, price: @item_1.price, quantity: 34 }
      item_order1 = ItemOrder.create!(item_order1_info)
      
      item_order2_info = { order_id: @order2.id, item_id: @item_2.id, price: @item_2.price, quantity: 20 }
      item_order2 = ItemOrder.create!(item_order2_info)
      
      item_order3_info = { order_id: @order1.id, item_id: @item_3.id, price: @item_3.price, quantity: 100 }
      item_order3 = ItemOrder.create!(item_order3_info)
      
      item_order4_info = { order_id: @order2.id, item_id: @item_4.id, price: @item_4.price, quantity: 27 }
      item_order4 = ItemOrder.create!(item_order4_info)
      
      item_order5_info = { order_id: @order1.id, item_id: @item_5.id, price: @item_5.price, quantity: 56 }
      item_order5 = ItemOrder.create!(item_order5_info)
      
      item_order6_info = { order_id: @order2.id, item_id: @item_6.id, price: @item_6.price, quantity: 23 }
      item_order6 = ItemOrder.create!(item_order6_info)
      
      item_order7_info = {order_id: @order1.id, item_id: @item_7.id, price: @item_7.price, quantity: 54 }
      item_order7 = ItemOrder.create!(item_order7_info)
      
      item_order8_info = {order_id: @order2.id, item_id: @item_1.id, price: @item_1.price, quantity: 35 }
      item_order8 = ItemOrder.create!(item_order8_info)

      expect(Item.most_popular_items).to eq([@item_3.name, @item_1.name, @item_5.name, @item_7.name, @item_4.name])
      
      expect(Item.least_popular_items).to eq([@item_2.name, @item_6.name, @item_4.name, @item_7.name, @item_5.name])
      
      # order1 has items : item1, item3, item5, item7
      # order2 has items : item2, item4, item6, item1
      # total quantities ordered :
      # item3 = 100
      # item1 = 69
      # item5 = 56
      # item7 = 54
      # item4 = 27
      # item6 = 23
      # item2 = 20
  end
  
end
end
