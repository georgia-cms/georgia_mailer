class MessagesController < ApplicationController

  def new
    @message = GeorgiaMailer::Message.new
  end

end