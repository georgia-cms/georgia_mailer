module Georgia
  class InboxPolicy < ApplicationPolicy

    def index?
      inbox_user_permissions(:read_messages).include?(true)
    end

    def search?
      index?
    end

    def show?
      index?
    end

    def destroy?
      inbox_user_permissions(:delete_messages).include?(true)
    end

    def spam?
      inbox_user_permissions(:mark_messages_as_spam).include?(true)
    end

    def ham?
      inbox_user_permissions(:mark_messages_as_ham).include?(true)
    end

    def print?
      inbox_user_permissions(:print_messages).include?(true)
    end

    def destroy_all_spam?
      inbox_user_permissions(:empty_trash).include?(true)
    end

    def resend_notification?
      index?
    end

    private

    def inbox_permissions
      Georgia.permissions[:inbox]
    end

    def inbox_user_permissions action
      user_permissions(inbox_permissions, action)
    end
  end
end