class LeaseReminderWorker
  include Sidekiq::Worker

  def perform

  end

  private

  def leases_close_to_expiration
    @leases_close_to_expiration ||= Lease.where("end_date <= '?' AND end_date >= " )
  end
end
