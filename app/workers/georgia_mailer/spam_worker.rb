module GeorgiaMailer
  class SpamWorker
    include Sidekiq::Worker

    def perform(message_id)
      begin
        @message = GeorgiaMailer::Message.find(message_id)
        is_spam = @message.spam?
        @message.update_attributes(spam: is_spam, verified_at: Time.zone.now)
        unless @message.spam or !GeorgiaMailer.turn_on_email_notifications
          GeorgiaMailer::Notifier.new_message_notification(@message).deliver
        end
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "Message with ID #{message_id} was destroy before it could be processed"
      end
    end

  end
end