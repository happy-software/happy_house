# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "noreply@happyhouse.live"
  layout "mailer"
end
