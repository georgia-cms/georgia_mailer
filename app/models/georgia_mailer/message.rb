module GeorgiaMailer
  class Message < ActiveRecord::Base

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    attr_accessible :name, :email, :subject, :message, :attachment, :phone
    delegate :url, :current_path, :size, :content_type, :filename, to: :attachment

    validates :name, presence: true
    validates :email, format: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    validates :message, presence: true

    mount_uploader :attachment, Ckeditor::AttachmentFileUploader

    # Anti Spam: check https://github.com/joshfrench/rakismet for more details
    include Rakismet::Model
    rakismet_attrs author: :name, author_email: :email, content: :message, comment_type: 'message'
    attr_accessible :user_ip, :user_agent, :referrer, :spam, :verified_at
    attr_accessor :permalink, :author_url

    scope :spam, where(spam: true)
    scope :ham, where(spam: false)
    scope :latest, order("created_at DESC")

    def status
      @status ||= spam ? 'spam' : 'clean'
    end

    def report_spam
      if self.spam!
        self.update_attribute(:spam, true)
      else
        false
      end
    end

    def move_to_inbox
      if !self.ham!
        self.update_attribute(:spam, false)
      else
        false
      end
    end

  end
end