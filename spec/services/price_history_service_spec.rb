# frozen_string_literal: true

require "rails_helper"

describe PriceHistoryService do
  let(:zpid)     { "abc" }
  let(:property) { double("property", zpid: zpid) }
  let(:instance) { described_class.new(property) }

  context "#get_history" do
    subject { instance.get_history }

    context "without a zpid" do
      let(:zpid) { nil }
      it { is_expected.to eq({}) }
    end

    context "with a proper response" do
      let(:response) { { "2019-03-13": "303844.0", "2019-03-14": "303699.0" } }
      let(:expected_summary) do
        { "March 2019" => 303_771.5 }
      end

      before { allow(instance).to receive(:call_api).and_return(response) }

      it { is_expected.to eq(expected_summary) }
    end
  end
end
