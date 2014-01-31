module GeorgiaMailer
  module Georgia
    class MessagesController < ::Georgia::ApplicationController

      load_and_authorize_resource class: GeorgiaMailer::Message

      before_filter :prepare_search, only: [:search, :show, :spam, :ham]


      def index
        redirect_to action: :search
      end

      def search
      end

      # Destroy multiple assets
      def destroy
        ids = params[:id].split(',')
        if @messages = GeorgiaMailer::Message.destroy(ids)
          render layout: false
        else
          head :internal_server_error
        end
      end

      def destroy_all_spam
        if GeorgiaMailer::Message.spam.destroy_all
          redirect_to :back, notice: 'All spam messages have been successfully deleted.'
        else
          redirect_to :back, alert: 'Oups. Something went wrong.'
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

      private

      def prepare_search
        @results = ::Georgia::Indexer.adapter.search(GeorgiaMailer::Message, params)
        @messages = GeorgiaMailer::MessageDecorator.decorate_collection(@results)
      end

    end
  end
end