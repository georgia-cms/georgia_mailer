module GeorgiaMailer
  class Notifier < ActionMailer::Base

    def new_message_notification(message)
      @message = GeorgiaMailer::MessageDecorator.decorate(message)
      emails_to = Georgia::User.admins.map(&:email)
      unless emails_to.empty?
        mail(
          from: "georgia@motioneleven.com",
          to: "noreply@motioneleven.com",
          bcc: emails_to,
          subject: "New message from #{Georgia.title}"
          )
      end
    end

  end
end
