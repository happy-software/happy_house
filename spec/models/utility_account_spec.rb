# frozen_string_literal: true

require "rails_helper"

RSpec.describe UtilityAccount, type: :model do
  it "has a valid factory belonging to a property" do
    utility_account = FactoryBot.create(:utility_account)

    expect(utility_account).to be_persisted
    expect(utility_account.property).to be_a(Property)
  end
end
