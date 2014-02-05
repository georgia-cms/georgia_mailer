namespace :messages do

  desc "Send to Akismet all unverified messages"
  task verify: :environment do
    puts "Check for spam. Currently have #{GeorgiaMailer::Message.spam.count} spam and #{GeorgiaMailer::Message.ham.count} ham messages."
    puts "Checking #{GeorgiaMailer::Message.where(verified_at: nil).count} unverified messages."
    GeorgiaMailer::Message.where(verified_at: nil).find_each do |message|
      message.update_attributes(spam: message.spam?, verified_at: Time.zone.now)
    end
    puts "Check completed. #{GeorgiaMailer::Message.spam.count} spam. #{GeorgiaMailer::Message.ham.count} ham."
  end

end

namespace :solr do

  namespace :messages do

    desc 'Reindex messages on solr'
    task reindex: :environment do
      GeorgiaMailer::Message.reindex
    end

  end

end