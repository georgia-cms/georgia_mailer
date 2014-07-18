module Georgia
  class MessagesController < Georgia::ApplicationController


    def show
      @message = Georgia::Mailer::Message.find(params[:id]).decorate
      authorize @message
    end

    def index
      authorize Georgia::Mailer::Message
      redirect_to georgia.search_messages_path
    end

    def search
      authorize Georgia::Mailer::Message
      search_definition = Georgia::Mailer::MessageSearch.new(params).definition
      @search = Georgia::Mailer::Message.search(search_definition).page(params[:page])
      @messages = Georgia::Mailer::MessageDecorator.decorate_collection(@search.records)
    end

    def destroy
      set_messages
      authorize @messages
      messages_count = @messages.length
      if @messages.destroy_all
        render_success("#{'Message'.pluralize(messages_count)} successfully deleted.")
      else
        render_error('Oups. Something went wrong.')
      end
    end

    def destroy_all_spam
      authorize Georgia::Mailer::Message
      Georgia::Mailer::DestroyAllSpamWorker.new.async.perform
      redirect_to search_messages_path(s: true), notice: 'Busy purging all spam messages.'
    end

    def spam
      set_messages
      authorize @messages
      begin
        if !@messages.map(&:report_spam).include?(false)
          render_success("#{'Message'.pluralize(@messages.length)} successfully reported as spam.")
        else
          render_error('Oups. Something went wrong.')
        end
      rescue Rakismet::Undefined => ex
        render_error(ex.message)
      end
    end

    def ham
      set_messages
      authorize @messages
      begin
        if !@messages.map(&:move_to_inbox).include?(false)
          render_success("#{'Message'.pluralize(@messages.length)} successfully moved to your inbox.")
        else
          render_error('Oups. Something went wrong.')
        end
      rescue => ex
        render_error(ex.message)
      end
    end

    def resend_notification
      @message = Georgia::Mailer::Message.find(params[:id])
      authorize @message
      if Georgia::Mailer::Notifier.new_message_notification(@message).deliver
        redirect_to :back, notice: 'Notification successfully sent.'
      else
        redirect_to :back, alert: 'Oups. Something went wrong. Message could not be delivered.'
      end
    end

    private

    def set_messages
      ids = params[:id].split(',')
      @messages = Georgia::Mailer::Message.where(id: ids)
    end

    def render_success success_message
      @status_message = success_message
      @status = :notice
      respond_to do |format|
        format.html { redirect_to :back, notice: @status_message }
        format.js   { render layout: false }
        format.json { render json: { ids: @messages.map(&:id), message: @status_message, status: @status } }
      end
    end

    def render_error error_message
      @status_message = error_message
      @status = :alert
      respond_to do |format|
        format.html { redirect_to :back, alert: @status_message }
        format.js   { render layout: false }
        format.json { render json: { message: @status_message, status: @status } }
      end
    end

  end
end