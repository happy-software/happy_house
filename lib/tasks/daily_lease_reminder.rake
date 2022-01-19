# frozen_string_literal: true

namespace :daily_lease_reminder_job do
  desc "Run the daily active lease expiration email reminder"
  task run: :environment do
    leases = Lease.active.select { |l| (l.end_date - 4.months).today? }
    leases.each { |l| LeaseMailer.with(lease: l).expiration_reminder.deliver_now }
  end
end
