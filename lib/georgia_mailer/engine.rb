module GeorgiaMailer
  class Engine < ::Rails::Engine
    isolate_namespace GeorgiaMailer

    require 'georgia'
    require 'rakismet'
    require 'sucker_punch'

  end
end