class MessagesController < ApplicationController

  def new
    @message = Georgia::Mailer::Message.new
  end

end