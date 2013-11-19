Rails.application.routes.draw do

  mount GeorgiaMailer::Engine => "/georgia_mailer"
end
