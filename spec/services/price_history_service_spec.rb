require 'rails_helper'

describe PriceHistoryService do
  let(:zpid)     { 'abc' }
  let(:instance) { described_class.new(zpid) }

  context '#get_history' do
    subject { instance.get_history }

    context 'without a zpid' do
      let(:zpid) { nil }
      it { is_expected.to eq({}) }
    end

    context 'without HappyHood backend endpoint set' do
      before { allow(instance).to receive(:api_path).and_return(nil) }
      it { is_expected.to eq({})}
    end

    context 'with a HappyHood endpoint set' do
      before { allow(instance).to receive(:api_path).and_return('https://superawesome.endpoint') }

      context 'with a proper response' do
        let(:api_response)  { OpenStruct.new(code: response_code, body: response_body) }
        let(:response_code) { 200 }
        let(:response_body) { '{"data":"some_data"}' }

        before { allow(instance).to receive(:call_api).and_return(api_response) }

        it { is_expected.to eq(JSON.parse(response_body)['data']) }
      end
    end
  end
end
