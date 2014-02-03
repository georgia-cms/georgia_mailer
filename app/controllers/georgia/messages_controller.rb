module Georgia
  class MessagesController < ::Georgia::ApplicationController

    load_and_authorize_resource class: GeorgiaMailer::Message

    before_filter :prepare_search, only: [:search, :show, :spam, :ham]


    def index
      redirect_to georgia.search_messages_path
    end

    def search
    end

    # Destroy multiple assets
    def destroy
      ids = params[:id].split(',')
      if @messages = GeorgiaMailer::Message.destroy(ids)
        respond_to do |format|
          format.html {
            redirect_to georgia.search_messages_path, notice: 'Messages successfully deleted.'
          }
          format.js { render layout: false }
        end
      else
        respond_to do |format|
          format.html {redirect_to georgia.search_messages_path, alert: 'Oups. Something went wrong.'}
          format.js {head :internal_server_error}
        end
      end
    end

    def show
      @message = GeorgiaMailer::Message.find(params[:id]).decorate
    end

    def spam
      @message = GeorgiaMailer::Message.find(params[:id])
      if @message.spam!
        @message.update_attribute(:spam, true)
        redirect_to :back, notice: 'Message successfully marked as spam.'
      else
        redirect_to :back, alert: 'Oups. Something went wrong.'
      end
    end

    def ham
      @message = GeorgiaMailer::Message.find(params[:id])
      if @message.ham! == false
        @message.update_attribute(:spam, false)
        redirect_to :back, notice: 'Message successfully marked as ham.'
      else
        redirect_to :back, alert: 'Oups. Something went wrong.'
      end
    end

    def resend_notification
      @message = GeorgiaMailer::Message.find(params[:id])
      if GeorgiaMailer::Notifier.new_message_notification(@message, message_path(@message, only_path: false)).deliver
        redirect_to :back, notice: 'Notification successfully sent.'
      else
        redirect_to :back, alert: 'Oups. Something went wrong. Message could not be delivered.'
      end
    end

    private

    def prepare_search
      @results = ::Georgia::Indexer.search(GeorgiaMailer::Message, params)
      @messages = GeorgiaMailer::MessageDecorator.decorate_collection(@results)
    end

  end
end