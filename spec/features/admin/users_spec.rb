require 'rails_helper'


describe "As an admin user" do
  it "takes me to the users link in the admin nav bar when I click on users" do
    user1 = create(:random_user)
    user2 = create(:random_user)
    user3 = create(:random_user)
    user4 = create(:random_user)

    admin_user = User.create!(name: "Bob T Builder",
                                street_address: "123 Contractor Blvd.",
                                city: "Fixit",
                                state: 'TN',
                                zip_code: "45678",
                                email: "yeswecan@example.com",
                                password: "hammertime7",
                                role: 2
                              )
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)


    visit '/admin'

    within 'nav' do
      click_on "Users"
    end

    expect(current_path).to eq("/admin/users")

    within "#user-#{user1.id}" do
      expect(page).to have_link(user1.name)
      expect(page).to have_content(user1.role)
      expect(page).to have_content(user1.created_at)
      click_on "#{user1.name}"
    end

    expect(current_path).to eq("/admin/users/#{user1.id}")

    visit "/admin/users"

    within "#user-#{user2.id}" do
      expect(page).to have_link(user2.name)
      expect(page).to have_content(user2.role)
      expect(page).to have_content(user2.created_at)
      click_on "#{user2.name}"
    end

    expect(current_path).to eq("/admin/users/#{user2.id}")

    visit "/admin/users"

    within "#user-#{user3.id}" do
      expect(page).to have_link(user3.name)
      expect(page).to have_content(user3.role)
      expect(page).to have_content(user3.created_at)
      click_on "#{user3.name}"
    end

    expect(current_path).to eq("/admin/users/#{user3.id}")

    visit "/admin/users"

    within "#user-#{user4.id}" do
      expect(page).to have_link(user4.name)
      expect(page).to have_content(user4.role)
      expect(page).to have_content(user4.created_at)
      click_on "#{user4.name}"
    end

    expect(current_path).to eq("/admin/users/#{user4.id}")
  end

  it "only admin users can reach this path." do
    walter = User.create!(name: "Walter White",
                                 street_address: "6230 Bluerock Ln",
                                 city: "Albuquerque",
                                 state: 'NM',
                                 zip_code: 44565,
                                 email: "heisenberg@example.com",
                                 password: "method3",
                                 role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(walter)

    visit "/admin/users"

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    johnny = User.create!(name: "Johnny",
                                street_address: "123 Jonny Way",
                                city: "Johnsonville",
                                state: 'TN',
                                zip_code: 12345,
                                email: "roman@example.com",
                                password: "hamburger01",
                                role: 1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(johnny)

    visit "/admin/users"

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
