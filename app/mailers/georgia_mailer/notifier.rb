module GeorgiaMailer
  class Notifier < ActionMailer::Base

    def new_message_notification(message)
      @message = GeorgiaMailer::MessageDecorator.decorate(message)
      emails_to = Georgia::User.where(receives_notifications: true).map(&:email)
      unless emails_to.empty?
        mail(
          from: "noreply@georgiacms.org",
          to: "noreply@georgiacms.org",
          bcc: emails_to,
          subject: "New message from #{Georgia.title}"
          )
      end
    end

  end
end
