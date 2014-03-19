module Georgia
  module MessagesHelper

    def message_actions_list(message)
      GeorgiaMailer::MessageActionsPresenter.new(self, message)
    end

  end
end