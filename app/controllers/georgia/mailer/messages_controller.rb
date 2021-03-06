module Georgia
  module Mailer
    class MessagesController < ::ApplicationController

      def create
        @message = Message.new(message_params)
        if @message.save
          Georgia::CreateActivity.new(@message, :create).call
          EmailDeliveryWorker.new.async.later(60, @message.id)
          SpamWorker.new.async.perform(@message.id)
          respond_to do |format|
            format.html { redirect_to :back, notice: 'Message delivered successfully' }
            format.js   { render layout: false }
          end
        else
          respond_to do |format|
            format.html { redirect_to :back, alert: 'Oups. Something went wrong.' }
            format.js   { render layout: false }
          end
        end
      end

      private

      def message_params
        @message_params = {}
        params[:message].each do |key, value|
          @message_params[key] = value.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        end
        @message_params[:referrer] = request.referrer
        @message_params[:user_ip] = request.remote_ip
        @message_params[:user_agent] = request.user_agent
        @message_params
      end

    end
  end
end