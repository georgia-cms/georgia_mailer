require "georgia_mailer/engine"

module GeorgiaMailer

  # Helper to turn off email notifications
  mattr_accessor :turn_on_email_notifications
  @@turn_on_email_notifications = true

  # Add to Georgia by default
  Georgia.navigation += %w(messages)

  Georgia.permissions.merge!(inbox: {
    read_messages:          { guest: false, contributor: false, editor: true,  admin: true, },
    print_messages:         { guest: false, contributor: false, editor: true,  admin: true, },
    mark_messages_as_spam:  { guest: false, contributor: false, editor: true,  admin: true, },
    mark_messages_as_ham:   { guest: false, contributor: false, editor: true,  admin: true, },
    delete_messages:        { guest: false, contributor: false, editor: true,  admin: true, },
    empty_trash:            { guest: false, contributor: false, editor: false, admin: true, },
  })

end
