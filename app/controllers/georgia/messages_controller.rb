module Georgia
  class MessagesController < ::Georgia::ApplicationController

    load_and_authorize_resource class: GeorgiaMailer::Message

    before_filter :prepare_search, only: :search


    def index
      redirect_to georgia.search_messages_path
    end

    def search
    end

    # Destroy multiple messages
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

    def destroy_all_spam
      GeorgiaMailer::DestroyAllSpamWorker.new.async.perform
      redirect_to search_messages_path(s: true), notice: 'Busy purging all spam messages.'
    end

    def show
      @message = GeorgiaMailer::Message.find(params[:id]).decorate
    end

    def spam
      ids = params[:id].split(',')
      @messages = GeorgiaMailer::Message.find(ids)
      if !@messages.map(&:report_spam!).include?(false)
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
      @messages = GeorgiaMailer::Message.find(ids)
      if !@messages.map(&:move_to_inbox!).include?(false)
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
      @message = GeorgiaMailer::Message.find(params[:id])
      if GeorgiaMailer::Notifier.new_message_notification(@message).deliver
        redirect_to :back, notice: 'Notification successfully sent.'
      else
        redirect_to :back, alert: 'Oups. Something went wrong. Message could not be delivered.'
      end
    end

    private

    def prepare_search
      @search = GeorgiaMailer::Message.search_index(params)
      @messages = GeorgiaMailer::MessageDecorator.decorate_collection(@search.results)
    end

  end
end