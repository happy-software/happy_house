require 'rails_helper'

describe ZpidFinder do
  let(:instance) { described_class.new(property) }
  let(:property) { double('property') }

  before do
    allow(instance).to receive(:call_api).and_return(response)
  end

  describe '#get_zpid' do
    subject { instance.get_zpid }

    context 'with a valid response' do
      let(:response) { {'zpid' => 'ayylmao'} }
      it { is_expected.to eq('ayylmao') }
    end

    context 'with no valid response' do
      let(:response) { {} }
      it { is_expected.to eq(nil) }
    end
  end
end
