require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "All user types can visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items images are links" do
      visit '/items'
      within "#item-#{@tire.id}" do
        find(:xpath, "//a/img[@alt='4e1f5b05 27ef 4267 bb9a 14e35935f218?size=784x588']/..").click
      end

      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'
      
      within "#item-#{@pull_toy.id}" do
       find(:xpath, "//a/img[@alt='Tug toy dog pull 9010 2 800x800']/..").click
      end

       expect(current_path).to eq("/items/#{@pull_toy.id}")

      visit '/items'

      within "#item-#{@dog_bone.id}" do
        find(:xpath, "//a/img[@alt='54226 main. ac sl1500 v1534449573 ']/..").click

      end

      expect(current_path).to eq("/items/#{@dog_bone.id}")
    end

    it "As an admin I can see the items index page " do
      admin_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 2
                                )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      visit '/'

      click_link "Items"

      expect(current_path).to eq("/items")
    end

    it "as a merchant I can see the items index page" do
      merchant_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 1
                                )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit '/'

      click_link "Items"

      expect(current_path).to eq("/items")
    end

    it "as a default_user I can see the items index page" do
      default_user = User.create!(name: "Johnny",
                                  street_address: "123 Jonny Way",
                                  city: "Johnsonville",
                                  state: 'TN',
                                  zip_code: 12345,
                                  email: "roman@example.com",
                                  password: "hamburger01",
                                  role: 0
                                )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/'

      click_link "Items"
      expect(current_path).to eq("/items")
    end

  end
end
