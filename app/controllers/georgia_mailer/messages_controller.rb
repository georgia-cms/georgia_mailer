module GeorgiaMailer
  class MessagesController < ::ApplicationController

    # Convenient method to create and check for spam
    def create
      @message = GeorgiaMailer::Message.new(message_params)
      if @message.valid? and @message.save
        SpamWorker.perform_async(@message.id)
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