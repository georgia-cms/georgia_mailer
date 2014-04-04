module GeorgiaMailer
  class MessageActionsPresenter < ::Georgia::Presenter

    def initialize view_context, message
      @message = (message.decorated? ? message.object : message)
      super
    end

    def to_s
      html = ActiveSupport::SafeBuffer.new
      # html << content_tag(:li, link_to_print)
      if spam?
        html << content_tag(:li, link_to_ham) if can?(:ham, @message)
      else
        html << content_tag(:li, link_to_spam) if can?(:spam, @message)
      end
      html << content_tag(:li, link_to_resend_notification)
      html << content_tag(:li, link_to_trash) if can?(:destroy, @message)
      html
    end

    private

    def link_to_print
      link_to "#{icon_tag('print')} Print".html_safe, "javascript:window.print()", target: '_blank', class: 'btn btn-warning btn-sm'
    end

    def link_to_reply
      link_to "#{icon_tag('reply')} Reply".html_safe, "mailto:#{@message.email}", target: '_blank', class: 'btn btn-warning btn-sm'
    end

    def link_to_ham
      link_to "#{icon_tag('thumbs-up')} Move to Inbox".html_safe, [:ham, @message], class: 'btn btn-warning btn-sm'
    end

    def link_to_spam
      link_to "#{icon_tag('thumbs-down')} Report spam".html_safe, [:spam, @message], class: 'btn btn-warning btn-sm'
    end

    def link_to_resend_notification
      link_to "#{icon_tag('envelope')} Resend notification".html_safe, [:resend_notification, @message], class: 'btn btn-warning btn-sm'
    end

    def link_to_trash
      link_to "#{icon_tag('trash-o')} Trash".html_safe, @message, method: :delete, data: {confirm: 'Are you sure?'}, class: 'btn btn-danger btn-sm'
    end

    def spam?
      @message.spam?
    end

  end
end