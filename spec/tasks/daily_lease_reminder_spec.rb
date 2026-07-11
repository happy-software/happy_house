# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "daily_lease_reminder_job:run", type: :task do
  before(:all) { Rails.application.load_tasks if Rake::Task.tasks.empty? }

  let(:task) { Rake::Task["daily_lease_reminder_job:run"] }
  let(:user)     { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }

  before do
    ActionMailer::Base.deliveries.clear
    task.reenable
  end

  it "emails a reminder for active leases ending exactly 4 months from today" do
    FactoryBot.create(:lease, property: property,
                              start_date: 8.months.ago, end_date: 4.months.from_now)

    task.invoke

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(ActionMailer::Base.deliveries.last.subject).to eq("Lease Expiration Reminder")
    expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
  end

  it "sends nothing for leases ending sooner or later, or already expired" do
    FactoryBot.create(:lease, property: property,
                              start_date: 7.months.ago, end_date: 5.months.from_now)
    FactoryBot.create(:lease, property: property,
                              start_date: 2.years.ago, end_date: 1.year.ago)

    task.invoke

    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
