module Georgia
  module Mailer
    class MailerPolicy < Georgia::ApplicationPolicy

      def index?
        mailer_user_permissions(:read_messages).include?(true)
      end

      def search?
        index?
      end

      def show?
        index?
      end

      def destroy?
        mailer_user_permissions(:delete_messages).include?(true)
      end

      def spam?
        mailer_user_permissions(:mark_messages_as_spam).include?(true)
      end

      def ham?
        mailer_user_permissions(:mark_messages_as_ham).include?(true)
      end

      def print?
        mailer_user_permissions(:print_messages).include?(true)
      end

      def destroy_all_spam?
        mailer_user_permissions(:empty_trash).include?(true)
      end

      def resend_notification?
        index?
      end

      private

      def mailer_permissions
        Georgia.permissions[:mailer]
      end

      def mailer_user_permissions action
        user_permissions(mailer_permissions, action)
      end
    end
  end
end