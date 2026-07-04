# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeaseFrequency, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:lease_frequency)).to be_persisted
  end
end
