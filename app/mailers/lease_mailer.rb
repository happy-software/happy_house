class LeaseMailer < ApplicationMailer
  def expiration_reminder
    @lease    = params[:lease]
    @property = @lease.property
    @user     = @property.user

    mail(to: @user.email, subject: 'Lease Expiration Reminder')
  end
end
