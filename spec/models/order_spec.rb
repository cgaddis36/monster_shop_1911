require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
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

      @order1 = @user1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 0)
      @order2 = @user2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: 1)
      @order3 = @user3.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 1)
      @order4 = @user4.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 2)
      @order5 = @user2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: 0)
      @order6 = @user3.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 2)
      @order7 = @user4.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 3)

      @order1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: 0)
      @order1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1, status: 0)
      @order1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 1, status: 0)

      @order2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 22, status: 1)
      @order3.item_orders.create!(item: @tire, price: @tire.price, quantity: 22, status: 1)
      @order4.item_orders.create!(item: @tire, price: @tire.price, quantity: 3, status: 0)
      @order5.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 22, status: 0)
      @order6.item_orders.create!(item: @tire, price: @tire.price, quantity: 22, status: 1)
      @order7.item_orders.create!(item: @tire, price: @tire.price, quantity: 3, status: 0)
    end
    it 'grandtotal' do
      expect(@order1.grandtotal).to eq(230)
    end

    it 'total_quantity' do
      expect(@order1.total_quantity).to eq(4)
    end

    it 'status_changer' do
      expect(@order1.status).to eq("pending")

      @order1.item_orders.update_all(status: "fulfilled")

      @order1.status_changer

      expect(@order1.status).to eq("packaged")
    end

    it "can find packaged orders" do
      expect(Order.packaged_status).to eq([@order2, @order3])
    end

    it "can find pending orders" do
      expect(Order.pending_status).to eq([@order1, @order5])
    end

    it "can find shipped orders" do
      expect(Order.shipped_status).to eq([@order4, @order6])
    end

    it "can find cancelled orders" do
      expect(Order.cancelled_status).to eq([@order7])
    end
  end
end
