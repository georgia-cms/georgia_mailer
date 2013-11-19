# encoding: UTF-8
require 'rails/generators/migration'
require 'rails/generators/active_record'

module GeorgiaMailer
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def mount_engine
        route "mount GeorgiaMailer::Engine => '/mailer'"
      end

      def self.next_migration_number(number)
        ActiveRecord::Generators::Base.next_migration_number(number)
      end

      def run_migrations
        migration_template "create_georgia_mailer_messages.rb", "db/migrate/create_georgia_mailer_messages.rb"
      end

      def display_message
        readme "README"
      end

    end
  end
end