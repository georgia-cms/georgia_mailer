module Georgia
  module Mailer
    class Engine < ::Rails::Engine
      isolate_namespace Georgia::Mailer

      require 'georgia'
      require 'rakismet'
      require 'sucker_punch'

    end
  end
end