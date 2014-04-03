require 'active_support/concern'

module Georgia
  module Indexer
    module SolrAdapter
      module GeorgiaMailerMessageExtension
        extend ActiveSupport::Concern

        included do

          searchable do
            text :name
            text :email
            text :message
            text :subject
            text :phone
            string :status
            string :name
            string :email
            string :phone
            string :subject
            string :message
            boolean :spam
            time :created_at
          end

          def self.search_index model, params
            search do
              fulltext params[:query] do
                fields(:name, :email, :message, :subject, :phone)
              end
              with(:spam, params[:s]) if params[:s].present?
              order_by (params[:o] || :created_at), (params[:dir] || :desc)
              paginate(page: params[:page], per_page: (params[:per] || 25))
            end
          end

        end
      end
    end
  end
end