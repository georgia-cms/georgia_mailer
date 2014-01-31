## Georgia Mailer

Extension to Georgia CMS to store and send messages. Messages will be treated for spam before being sent to you.

Make sure you have a working Georgia installation before proceding with these instructions.

### Installation

Add migrations and migrate

    rake railties:install:migrations
    rake db:migrate

If you selected ElasticSearch as your indexer, create the GeorgiaMailer::Message index:

    rake environment tire:import CLASS=GeorgiaMailer::Message FORCE=true

### Heroku

Add Redis addon for Sidekiq

    heroku addons:add redistogo

Generate GeorgiaMailer::Message index:

    heroku run rake environment tire:import CLASS=GeorgiaMailer::Message FORCE=true

Add sidekiq to your Procfile:

    worker: bundle exec sidekiq

### Spam filtering

To avoid pesky spammers, Georgia Mailer uses Akismet system to filter spam messages.

1. Sign up on [http://akismet.com/signup/](http://akismet.com/signup/)
2. Configure rakismet `key` and `url` in an initializer:

```ruby
# config/initializers/rakismet.rb
Example::Application.config.rakismet.key = '123456789XYZ'
Example::Application.config.rakismet.url = 'https://www.example.com/'
```

For more information or alternatives, please read on the [rakismet](https://github.com/joshfrench/rakismet) gem.