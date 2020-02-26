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
plant_shop = Merchant.create(name: "Kelly's Gardens", address: '4456 Flower Ave.', city: 'Gardenia', state: 'NY', zip: 77890)
music_shop = Merchant.create(name: "Chase's Tasty Jams", address: '4435 Les Paul Ave', city: 'Telluride', state: 'CO', zip: 90879)
fly_shop = Merchant.create(name: "Franks's Fly's & Ties", address: '6678 Fly St.', city: 'Durango', state: 'CO', zip: 80010)
bee_shop = Merchant.create(name: "Alex's Bee Gardens", address: '6678 Bzzz Rd.', city: 'Paris', state: 'TX', zip: 60700)
ski_shop = Merchant.create(name: "Travis's Sleds & Shreds", address: '5467 Pow St.', city: 'Jackson', state: 'WY', zip: 34567)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

#plant_shop items
azaleas = plant_shop.items.create(name: "Azaleas", description: "Gorgeous plants, dogs love them.", price: 15, image: "https://www.directgardening.com/1718-thickbox_default/pink-azalea.jpg", inventory: 100)
palm = plant_shop.items.create(name: "Palm Tree", description: "I like coconuts!", price: 50, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 50)
roses = plant_shop.items.create(name: "Roses", description: "Smells like teen spirit", price: 30, image: "https://richmedia.channeladvisor.com/ImageDelivery/imageService?profileId=12026540&id=1127763&recipeId=728", inventory: 44)
sod = plant_shop.items.create(name: "Sod", description: "Don't sod, ya cry baby", price: 20, image: "https://www.centralsodil.com/media/catalog/product/cache/5/image/650x/040ec09b1e35df139433887a97daa66f/s/o/sod_1.jpg", inventory: 67)
soil = plant_shop.items.create(name: "Soil", description: "Manure....", price: 8, image: "https://images.homedepot-static.com/productImages/8d51618a-abef-4199-9eb8-c8030f7fd37c/svn/miracle-gro-garden-soil-75030430-64_1000.jpg", inventory: 300)

#music_shop items
guitar = music_shop.items.create(name: "Languedoc", description: "Trey shred one, so can you!", price: 10000, image: "https://s-media-cache-ak0.pinimg.com/236x/29/ae/ff/29aeffadf8ab32379d37b8605e79b1fe.jpg", inventory: 1)
drums = music_shop.items.create(name: "Drums", description: "Bang these bad boys all day", price: 5000, image: "https://i.pinimg.com/originals/fe/da/c2/fedac2f25210eba4fec16e52196ff9d8.jpg", inventory: 12)
bass = music_shop.items.create(name: "Bass", description: "Okayist Bassist", price: 4500, image: "https://www.premierguitar.com/ext/resources/images/content/2015-02/Rig-Rundowns/Umphreys-McGee/Stasik-Bass-WEB.jpg", inventory: 3)
keys = music_shop.items.create(name: "Keys", description: "Electrify the crowd", price: 4000, image: "https://pagemcconnell.com/wp-content/uploads/2012/02/DSC_0029-e1359740978493-192x192.jpg", inventory: 5)

#fly_shop items
rod = fly_shop.items.create(name: "Fly Rod", description: "Sage x240", price: 310, image: "https://lh3.googleusercontent.com/proxy/AMtWz71cFKLIGhrCZ5kKiF1MxCcW4crJn6Ar-26ytb757EzIW8WHUvjpO4jYhyitP2LXxDvunuWn1y6d2WWXdOFrQFE5AKMF5OcaEsuK7nUdsJ631ewlMfsx8jfydKqRENStm58GCS8", inventory: 14)
reel = fly_shop.items.create(name: "Fly Reel", description: "Abel Super 5wt", price: 600, image: "https://www.rossreels.com/rr-news/abel-reels/wp-content/uploads/sites/7/2017/01/ss-wt-1.png", inventory: 20)
dog_bone = fly_shop.items.create(name: "Dog Bone", description: "Fish can't see or break it!", price: 60, image: "https://cdn11.bigcommerce.com/s-h8h1haj1/images/stencil/1280x1280/products/425/1800/20190117_191540__27881.1547775957.jpg?c=2&imbypass=on", inventory: 100)

#bee_shop items
colony = bee_shop.items.create(name: "Colony", description: "Buzz Buzz", price: 150, image: "https://cdn.shopify.com/s/files/1/0123/6556/1915/products/Bees_at_bee_friends_fram_2.jpeg?v=1567775402", inventory: 150)
mask = bee_shop.items.create(name: "Mask", description: "Face protection", price: 50, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 175)
gloves = bee_shop.items.create(name: "Roses", description: "Smells like teen spirit", price: 30, image: "https://richmedia.channeladvisor.com/ImageDelivery/imageService?profileId=12026540&id=1127763&recipeId=728", inventory: 404)
suit = bee_shop.items.create(name: "Sod", description: "Don't sod, ya cry baby", price: 20, image: "https://www.centralsodil.com/media/catalog/product/cache/5/image/650x/040ec09b1e35df139433887a97daa66f/s/o/sod_1.jpg", inventory: 20)
hive = bee_shop.items.create(name: "Soil", description: "Manure....", price: 8, image: "https://images.homedepot-static.com/productImages/8d51618a-abef-4199-9eb8-c8030f7fd37c/svn/miracle-gro-garden-soil-75030430-64_1000.jpg", inventory: 122)


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
