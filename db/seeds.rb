# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

merchant_user1 = bike_shop.users.create!(name: "Johnny",
                            street_address: "123 Jonny Way",
                            city: "Johnsonville",
                            state: 'TN',
                            zip_code: 12345,
                            email: "roman4@example.com",
                            password: "hamburger042",
                            role: 1
                          )

merchant_user2 = bike_shop.users.create!(name: "Jeremiah",
                            street_address: "7777 Rastafari Way",
                            city: "Jamaica",
                            state: 'FL',
                            zip_code: 46766,
                            email: "bobbymarley@example.com",
                            password: "irie333",
                            role: 1
                          )

admin_user = User.create!(name: "Johnny",
                            street_address: "123 Jonny Way",
                            city: "Johnsonville",
                            state: 'TN',
                            zip_code: 12345,
                            email: "roman3@example.com",
                            password: "hamburger043",
                            role: 2
                          )

default_user = User.create!(name: "Johnny",
                            street_address: "123 Jonny Way",
                            city: "Johnsonville",
                            state: 'TN',
                            zip_code: 12345,
                            email: "roman5@example.com",
                            password: "hamburger03",
                            role: 0
                          )

merchant = create(:random_merchant)

merchant2 = create(:random_merchant)

@item1 = create(:random_item, merchant: @merchant)
@item2 = create(:random_item, merchant: @merchant)
@item3 = create(:random_item, merchant: @merchant)
@item4 = create(:random_item, merchant: @merchant)
@item5 = create(:random_item, merchant: @merchant)
@item6 = create(:random_item, merchant: @merchant)
@item7 = create(:random_item, merchant: @merchant)
@item8 = create(:random_item, merchant: @merchant)
@item9 = create(:random_item, merchant: @merchant)

@item10 = create(:random_item, merchant: @merchant2)
@item11 = create(:random_item, merchant: @merchant2)
@item12 = create(:random_item, merchant: @merchant2)
@item13 = create(:random_item, merchant: @merchant2)
@item14 = create(:random_item, merchant: @merchant2)
@item15 = create(:random_item, merchant: @merchant2)
@item16 = create(:random_item, merchant: @merchant2)
@item17 = create(:random_item, merchant: @merchant2)
@item18 = create(:random_item, merchant: @merchant2)
@item19 = create(:random_item, merchant: @merchant2)


