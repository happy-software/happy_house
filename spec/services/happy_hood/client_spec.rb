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
      let(:stubbed_response) { double('response', code: '200', body: stubbed_body) }
      let(:stubbed_body) { '{"data":{"2019-03-13": "303844.0", "2019-03-14":"303699.0"}}' }
      let(:uri) { URI("http://somepath.wtf/#{zpid}") }
      before do
        allow(instance).to receive(:api_path).and_return('http://somepath.wtf')
        Rails.cache.delete("#{Date.today.strftime("%Y-%m-%d")}-#{zpid}")
      end

      it 'tries to make a request' do
        expect(Net::HTTP).to receive(:start).with(uri.hostname, uri.port).and_return(stubbed_response)
        subject
      end
    end
  end
end