require 'rails_helper'
require_relative '../../../app/services/happy_hood/client'

describe HappyHoodService do
  let(:instance) { described_class.new(property) }
  let(:property) { double('property', zpid: zpid) }
  let(:zpid)     { 'some-zpid-value' }

  describe '#get_history' do
    subject { instance.get_history }

    it 'makes a request' do
      expect(instance).to receive(:make_request).with(endpoint: :valuations)
      subject
    end

    context 'without valid api endpoint' do
      before { allow(instance).to receive(:api_path) }
      it { is_expected.to eq({}) }
    end

    context 'with an api endpoint defined' do
      before { allow(instance).to receive(:api_path).and_return('http://somepath.wtf') }
      it 'tries to make a request' do
        expect(Net::HTTP).to receive(:get).with(URI("http://somepath.wtf/#{zpid}"))
        subject
      end
    end
  end
end