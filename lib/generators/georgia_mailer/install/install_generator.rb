module GeorgiaMailer
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      def mount_engine
        route "mount GeorgiaMailer::Engine => '/mailer'"
      end

      def run_migrations
        rake "railties:install:migrations"
        rake "db:migrate"
      end

      def create_indices
        if defined? Tire
          say("Creating elasticsearch indices", :yellow)
          rake "environment tire:import CLASS=GeorgiaMailer::Message FORCE=true"
        end
      end

    end
  end
end