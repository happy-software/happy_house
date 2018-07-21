require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user' do
    let(:user) { User.new(name: 'Hebron George', email: 'me@hebrongeorge.com') }

    it { expect(user.valid?).to eq true }
  end
end
