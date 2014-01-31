require 'spec_helper'

describe GeorgiaMailer::Message do
  specify {FactoryGirl.build(:georgia_mailer_message).should be_valid}

  it { should respond_to :name, :email, :subject, :message, :attachment }

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:message)}

  it {should allow_value('whereis@waldo.com').for(:email)}
  it {should_not allow_value('waldo.com').for(:email)}
  it {should_not allow_value('whereis@waldo').for(:email)}
  it {should_not allow_value('@waldo.com').for(:email)}

  describe ".search" do

    it 'has an indexer extension' do
      GeorgiaMailer::Message.should respond_to :search
    end
    
  end

end