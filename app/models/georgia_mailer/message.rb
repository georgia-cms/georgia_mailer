module GeorgiaMailer
  class Message < ActiveRecord::Base

    attr_accessible :name, :email, :subject, :message, :attachment, :phone
    delegate :url, :current_path, :size, :content_type, :filename, to: :attachment

    validates :name, presence: true
    validates :email, format: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    validates :message, presence: true

    mount_uploader :attachment, Georgia::AttachmentUploader

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

    include Georgia::Indexer
    # is_searchable :georgia_mailer_message

    include ::Tire::Model::Search
    include ::Tire::Model::Callbacks

    def to_indexed_json
      {
        name: name,
        email: email,
        message: message,
        subject: subject,
        phone: phone,
        status: status,
        created_at: created_at.strftime('%F')
      }.to_json
    end

    def self.search model, params
      model.tire.search(page: (params[:page] || 1), per_page: (params[:per] || 25)) do
        if params[:query].present?
          query do
            boolean do
              must { string params[:query], default_operator: "AND" }
            end
          end
          sort { by (params[:o] || :created_at), (params[:dir] || :desc) }
        end
      end.results
    end

  end
end