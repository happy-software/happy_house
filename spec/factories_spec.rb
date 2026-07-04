# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Factories" do
  %i[user property lease event expense_item insurance_document
     purchase_document mortgage_statement tenant lease_tenant].each do |name|
    it "#{name} factory is valid" do
      expect(FactoryBot.create(name)).to be_persisted
    end
  end

  it "user :activated trait works" do
    expect(FactoryBot.create(:user, :activated)).to be_activated
  end
end
