# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:event)).to be_persisted
  end

  it "requires a property" do
    expect(FactoryBot.build(:event, property: nil).valid?).to eq(false)
  end

  it "stores rich-text content" do
    event = FactoryBot.create(:event)
    event.update!(content: "<div>Annual <strong>inspection</strong></div>")

    expect(event.reload.content.to_plain_text).to include("Annual inspection")
  end
end
