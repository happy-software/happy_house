require 'rails_helper'

describe 'HappyHouse::PropertyInterface' do
  after do
    Property.destroy_all
    User.destroy_all
  end

  context '#transfer_ownership' do
    let(:property) { FactoryBot.create(:property, user: original_user) }
    let(:instance) { property.property_interface }
    let(:original_user) { FactoryBot.create(:user) }
    let(:new_user)      { FactoryBot.create(:user) }

    it 'succeeds' do
      expect(instance.user).to eq(original_user)
      instance.transfer_ownership(new_user)
      expect(instance.user).to eq(new_user)
    end
  end
end