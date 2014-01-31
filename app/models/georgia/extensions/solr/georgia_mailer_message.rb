require 'active_support/concern'

module Georgia
  module Indexer
    module Extensions
      module Solr
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

        end
      end
    end
  end
end