require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user' do
    let(:user) { User.new(name: 'Hebron George', email: 'me@hebrongeorge.com') }

    it { expect(user.valid?).to eq true }
  end

  describe 'invalid user' do
    let(:user) { User.new(name: name, email: email) }
    let(:name) { 'Hebron George' }
    let(:email) { 'me@hebrongeorge.com' }

    context 'blank name' do
      let(:name) { '      ' }
      it { expect(user.valid?).to eq false }
    end

    context 'blank email' do
      let(:email) { '     ' }
      it { expect(user.valid?).to eq false }
    end
  end
end
