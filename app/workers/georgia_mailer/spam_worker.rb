module GeorgiaMailer
  class SpamWorker
    include SuckerPunch::Job

    def perform(message_id)
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          message = Message.find(message_id)
          is_spam = SpamCheck.new(message).call
          message.update_attributes(spam: is_spam, verified_at: Time.zone.now)
        rescue ActiveRecord::RecordNotFound
          Rails.logger.info "Message with ID #{message_id} was destroy before it could be processed"
        end
      end
    end

  end
end