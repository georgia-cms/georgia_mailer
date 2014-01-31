module GeorgiaMailer
  class Engine < ::Rails::Engine
    isolate_namespace GeorgiaMailer

    require 'rakismet'
    require 'sidekiq'

  end
end