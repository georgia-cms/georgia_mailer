module Georgia
  module Mailer
    class EmailDeliveryWorker
      include SuckerPunch::Job

      def perform(message_id)
        ActiveRecord::Base.connection_pool.with_connection do
          message = Message.find(message_id)
          unless message.spam or !Georgia::Mailer.turn_on_email_notifications
            Notifier.new_message_notification(message).deliver
          end
        end
      end

      def later(sec, message_id)
        after(sec) { perform(message_id) }
      end

    end
  end
end