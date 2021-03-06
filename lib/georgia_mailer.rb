require "georgia/mailer/engine"

module Georgia
  module Mailer

    # Helper to turn off email notifications
    mattr_accessor :turn_on_email_notifications
    @@turn_on_email_notifications = true

    # Add to Georgia by default
    Georgia.navigation += %w(messages)

    Georgia.permissions.merge!(mailer: {
      read_messages:          { communications: true,  admin: true, },
      print_messages:         { communications: true,  admin: true, },
      mark_messages_as_spam:  { communications: true,  admin: true, },
      mark_messages_as_ham:   { communications: true,  admin: true, },
      delete_messages:        { communications: true,  admin: true, },
      empty_trash:            { communications: false, admin: true, },
    })

    Georgia.roles += %w(communications)

  end
end
