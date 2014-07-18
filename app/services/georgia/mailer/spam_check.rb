module Georgia
  module Mailer
    class SpamCheck

      def initialize message
        @message = message
      end

      # The .spam? method comes from Rakismet. It gathers the necessary information and
      #   and calls Akismet for a spam check. It returns true or false based on the status
      #
      # https://github.com/joshfrench/rakismet/blob/master/lib/rakismet/model.rb
      def call
        @message.spam?
      end

    end
  end
end