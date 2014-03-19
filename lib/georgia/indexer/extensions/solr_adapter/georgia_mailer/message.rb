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
            string :spam do
              status
            end
            string :name
            string :email
            string :phone
            string :subject
            string :message
            time :created_at
          end

          def self.search_index model, params
            search do
              fulltext params[:query] do
                fields(:name, :email, :message, :subject, :phone)
              end
              facet :spam
              with(:spam, (params[:s] || 'clean'))
              order_by (params[:o] || :created_at), (params[:dir] || :desc)
              paginate(page: params[:page], per_page: (params[:per] || 25))
            end.results
          end

        end
      end
    end
  end
end