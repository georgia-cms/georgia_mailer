namespace :georgia do
  namespace :mailer do

    desc "Send to Akismet all unverified messages"
    task verify: :environment do
      puts "Check for spam. Currently have #{Georgia::Mailer::Message.spam.count} spam and #{Georgia::Mailer::Message.ham.count} ham messages."
      puts "Checking #{Georgia::Mailer::Message.where(verified_at: nil).count} unverified messages."
      Georgia::Mailer::Message.where(verified_at: nil).find_each do |message|
        message.update_attributes(spam: message.spam?, verified_at: Time.zone.now)
      end
      puts "Check completed. #{Georgia::Mailer::Message.spam.count} spam. #{Georgia::Mailer::Message.ham.count} ham."
    end

    namespace :elasticsearch do

      desc "Setup ElasticSearch index"
      task setup: :environment do
        Georgia::Mailer::Message.__elasticsearch__.client.indices.delete index: Georgia::Mailer::Message.index_name rescue nil
        Georgia::Mailer::Message.__elasticsearch__.create_index! force: true
        Georgia::Mailer::Message.import
      end

    end

  end
end