Rails.application.routes.draw do

  mount GeorgiaMailer::Engine => '/mailer'

  root to: 'messages#new'

end
