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

          def self.search_index params
            page     = params.fetch(:page, 1)
            per_page = params.fetch(:per, 25)

            search(page: page, per_page: per_page) do
              if params[:query].present?
                query do
                  boolean do
                    must { string params[:query], default_operator: "AND" }
                  end
                  # TODO: filter for spam
                end
              end
              sort { by (params[:o] || :created_at), (params[:dir] || :desc) } if params[:query].blank?
            end
          end

        end
      end
    end
  end
end