module GeorgiaMailer
  class Engine < ::Rails::Engine
    isolate_namespace GeorgiaMailer

    require 'georgia'
    require 'rakismet'
    require 'sidekiq'

  end
end