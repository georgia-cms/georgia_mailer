module GeorgiaMailer
  class DestroyAllSpamWorker
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          GeorgiaMailer::Message.destroy_all(spam: true)
        rescue ActiveRecord::RecordNotFound
          Rails.logger.info "Message with ID #{message_id} was destroy before it could be processed"
        end
      end
    end

  end
end