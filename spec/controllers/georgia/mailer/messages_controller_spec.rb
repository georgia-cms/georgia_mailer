# encoding: UTF-8
require 'spec_helper'

describe Georgia::Mailer::MessagesController do

  before :each do
    Georgia::Mailer::SpamWorker.stub(:perform_async).and_return(true)
  end

  after :each do
    expect(assigns(:message)).to be_a(Georgia::Mailer::Message)
  end

  it "creates a Georgia::Mailer::Message" do
    post(:create, use_route: :mailer, message: {name: "John", phone: '123-456-7890', subject: 'Testing', message: "It's a beautiful day." }, format: 'js')
    expect(response).to be_successful
    expect(response).to render_template(:create)
  end

  it "avoids UTF-8 Invalid Byte Sequences" do
    name = "MCM ¥ê¥å¥Ã¥¯ °×\255".force_encoding('UTF-8')
    email = "uyiohttu*@gmail.com\255".force_encoding('UTF-8')
    phone = "http://www.bluedogglass.com.au/home-gallery/mcmofficial.html\255".force_encoding('UTF-8')
    message = "A great deal has occured in the world of and also carbon finance and pollution levels exchanging due to the fact most people final published relating to this subject, thus i felt this really is good time to provide a quick upgrade. Any. The planet Standard bank As well as Finance Component lately produced its State and Trends of the As well as Market place Two thousand and seven (Document document), any intermittent assessment of the degree and properties of the world-wide promote for carbon dioxide pollution levels..\n <a href=\"http://www.bluedogglass.com.au/home-gallery/mcmofficial.html\" title=\"MCM ¥ê¥å¥Ã¥¯ °×\">MCM ¥ê¥å¥Ã¥¯ °×</a>\255".force_encoding('UTF-8')
    post(:create, use_route: :mailer, message: {
      name: name,
      email: email,
      phone: phone,
      message: message},
      format: 'js',
      utf8: "?")
    expect(response).to be_successful
    expect(response).to render_template(:create)
  end

  it "renders html format" do
    request.env["HTTP_REFERER"] = "/"
    post(:create, use_route: :mailer, message: {name: "John", phone: '123-456-7890', subject: 'Testing', message: "It's a beautiful day." }, format: 'html')
    expect(response).to redirect_to('/')
  end

end