module Georgia
  class MessagesController < Georgia::ApplicationController

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

    # Destroy multiple messages
    def destroy
      authorize Georgia::Mailer::Message
      ids = params[:id].split(',')
      if @messages = Georgia::Mailer::Message.destroy(ids)
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

    def destroy_all_spam
      authorize Georgia::Mailer::Message
      Georgia::Mailer::DestroyAllSpamWorker.new.async.perform
      redirect_to search_messages_path(s: true), notice: 'Busy purging all spam messages.'
    end

    def show
      @message = Georgia::Mailer::Message.find(params[:id]).decorate
      authorize @message
    end

    def spam
      ids = params[:id].split(',')
      @messages = Georgia::Mailer::Message.find(ids)
      authorize @messages
      if !@messages.map(&:report_spam).include?(false)
        respond_to do |format|
          format.html {
            redirect_to :back, notice: "#{'Message'.pluralize(@messages.length)} successfully reported as spam."
          }
          format.js { render layout: false }
          format.json { render json: @messages.map(&:id) }
        end
      else
        respond_to do |format|
          format.html {redirect_to :back, alert: 'Oups. Something went wrong.'}
          format.js {head :internal_server_error}
          format.json {head :internal_server_error}
        end
      end
    end

    def ham
      ids = params[:id].split(',')
      @messages = Georgia::Mailer::Message.find(ids)
      authorize @messages
      if !@messages.map(&:move_to_inbox).include?(false)
        @notification = "#{'Message'.pluralize(@messages.length)} successfully moved to your inbox."
        respond_to do |format|
          format.html { redirect_to :back, notice: @notification }
          format.js { render layout: false }
          format.json { render json: @messages.map(&:id) }
        end
      else
        respond_to do |format|
          format.html {redirect_to :back, alert: 'Oups. Something went wrong.'}
          format.js {head :internal_server_error}
          format.json {head :internal_server_error}
        end
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

  end
end