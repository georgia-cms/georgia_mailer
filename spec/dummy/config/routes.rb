Rails.application.routes.draw do

  mount GeorgiaMailer::Engine => '/mailer'

end
