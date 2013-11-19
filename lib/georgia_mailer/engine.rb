module GeorgiaMailer
  class Engine < ::Rails::Engine
    isolate_namespace GeorgiaMailer

    require 'sendgrid'
    require 'rakismet'
    require 'carrierwave'
    require 'fog'
    require 'sunspot_rails'

  end
end