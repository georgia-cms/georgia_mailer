module GeorgiaMailer
  class MessageActionsPresenter < ::Georgia::Presenter

    def initialize view_context, message
      @message = (message.decorated? ? message.object : message)
      super
    end

    def to_s
      html = ActiveSupport::SafeBuffer.new
      if @message.spam
        html << link_to_ham# if can?(:ham, @message)
      else
        html << link_to_spam# if can?(:spam, @message)
      end
      html << link_to_resend_notification
      html << link_to_trash# if can?(:destroy, @message)
      html
    end

    private

    def link_to_ham
      link_to "#{icon_tag('thumbs-up')} Move to Inbox".html_safe, [:ham, @message], method: :post, class: 'btn btn-warning btn-sm'
    end

    def link_to_spam
      link_to "#{icon_tag('exclamation-triangle')} Report spam".html_safe, [:spam, @message], method: :post, class: 'btn btn-warning btn-sm'
    end

    def link_to_resend_notification
      link_to "#{icon_tag('envelope')} Resend notification".html_safe, [:resend_notification, @message], class: 'btn btn-warning btn-sm'
    end

    def link_to_trash
      link_to "#{icon_tag('trash-o')} Trash".html_safe, @message, method: :delete, data: {confirm: 'Are you sure?'}, class: 'btn btn-danger btn-sm'
    end

  end
end