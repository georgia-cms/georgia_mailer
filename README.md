## Georgia Mailer

Extension to Georgia CMS to store and send messages. Messages will be treated for spam before being sent to you.

Make sure you have a working Georgia installation before proceding with these instructions.

### Installation

The install generator will add missing migrations and automatically migrate your database.
If you selected ElasticSearch as your indexer with Tire, your index will be created.
Finally, it will mount the engine in your routes.rb file under '/mailer'

    rails generate georgia_mailer:install

### Heroku

Generate GeorgiaMailer::Message index:

    heroku run rake environment georgia:mailer:create_indices

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