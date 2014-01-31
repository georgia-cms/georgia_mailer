## Georgia Mailer

Extension to Georgia CMS to store and send messages. Messages will be treated for spam before being sent to you.

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