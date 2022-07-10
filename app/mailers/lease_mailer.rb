# frozen_string_literal: true

class LeaseMailer < ApplicationMailer
  def expiration_reminder
    @lease    = params[:lease]
    @property = @lease.property
    @user     = @property.user
    @url      = user_property_lease_renew_current_lease_url(@user.id, @property.id, @lease.id, id: @lease.id)

    mail(to: @user.email, subject: "Lease Expiration Reminder")
  end
end
