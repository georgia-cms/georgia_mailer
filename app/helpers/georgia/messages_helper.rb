module Georgia
  module MessagesHelper

    def message_actions_list(message)
      Mailer::MessageActionsPresenter.new(self, message)
    end

  end
end