require 'rails_helper'

describe Coupon, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :item_quantity}
    it {should validate_inclusion_of(:value).in_array((0..100).to_a).with_message("must be between 0 and 100.")}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :orders}
  end

end
