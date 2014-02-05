require 'active_support/concern'

module Georgia
  module Indexer
    module TireAdapter
      module GeorgiaMailerMessageExtension
        extend ActiveSupport::Concern

        included do

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

          def self.search_index model, params
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
    end
  end
end