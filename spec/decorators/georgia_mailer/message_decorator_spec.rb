require 'spec_helper'

describe Georgia::Mailer::MessageDecorator do

  subject {Georgia::Mailer::MessageDecorator.decorate(FactoryGirl.build(:georgia_mailer_message))}

  it {respond_to :phone_or_none}
  it {respond_to :subject_truncated}
  it {respond_to :message_truncated}
  it {respond_to :name_or_anonymous}

end