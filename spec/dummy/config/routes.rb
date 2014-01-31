Rails.application.routes.draw do

  mount GeorgiaMailer::Engine => '/mailer'
  mount Georgia::Engine => '/admin'

  root to: 'messages#new'

end
