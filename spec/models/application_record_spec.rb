# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationRecord do
  describe ".newest / .oldest" do
    let!(:older) { FactoryBot.create(:user) }
    let!(:newer) { FactoryBot.create(:user) }

    before do
      older.update_columns(created_at: 2.days.ago)
      newer.update_columns(created_at: 1.hour.ago)
    end

    it "newest returns the most recently created record" do
      expect(User.newest).to eq(newer)
    end

    it "oldest returns the earliest created record" do
      expect(User.oldest).to eq(older)
    end
  end
end
