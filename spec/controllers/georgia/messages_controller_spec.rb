require 'spec_helper'

describe Georgia::MessagesController do
  include Devise::TestHelpers

  before :each do
    @current_user = create(:georgia_admin_user)
    controller.class.skip_before_filter :authenticate_user!
    controller.stub current_user: @current_user
  end

  describe "GET search" do

    it "should have a status code of 200" do
      get :search, use_route: :admin
      response.should be_ok
    end

  end

  describe "GET index" do

    it "should redirect to search" do
      get :index, use_route: :admin
      response.should be_redirect
    end

  end

  describe "GET show" do

    it "should redirect to edit" do
      @message = create(:georgia_mailer_message)
      get :show, use_route: :admin, id: @message.id
      response.should be_ok
    end

  end


  describe "DELETE destroy" do

    it "should redirect to search" do
      @message = create(:georgia_mailer_message)
      delete :destroy, use_route: :admin, id: @message.id
      response.should be_redirect
    end

    it "should destroy many messages" do
      @messages = []
      @messages << create(:georgia_mailer_message)
      @messages << create(:georgia_mailer_message)
      delete :destroy, use_route: :admin, id: @messages.map(&:id).join(',')
      assigns(:messages).each do |message|
        expect(message.persisted?).to be false
      end
    end

  end

end