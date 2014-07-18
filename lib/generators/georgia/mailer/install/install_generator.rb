module Georgia
  module Mailer
    module Generators
      class InstallGenerator < ::Rails::Generators::Base

        def mount_engine
          route "mount Georgia::Mailer::Engine => '/mailer'"
        end

        def run_migrations
          rake "railties:install:migrations"
          rake "db:migrate"
        end

        def create_index
          Georgia::Mailer::Message.__elasticsearch__.indices.delete! Georgia::Mailer::Message.index_name rescue nil
          Georgia::Mailer::Message.__elasticsearch__.create_index! force: true
          Georgia::Mailer::Message.import
        end

      end
    end
  end
end