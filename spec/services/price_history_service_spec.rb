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
        let(:response_body) { '{"data":{"2019-03-13": "303844.0", "2019-03-14":"303699.0"}}' }
        let(:expected_summary) do
          {'March 2019' => 303771.5}
        end

        before { allow(instance).to receive(:call_api).and_return(api_response) }

        it { is_expected.to eq(expected_summary) }
      end
    end
  end
end
