require "georgia_mailer/engine"

module GeorgiaMailer

  # Helper to turn off email notifications
  mattr_accessor :turn_on_email_notifications
  @@turn_on_email_notifications = true

  # Add to Georgia by default
  Georgia.navigation += %w(messages)

end
